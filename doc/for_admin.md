# For administrator

Thank you for maintaining the server! ☕️

---
CHANGE LOG: Mon Apr 25, 2022, Runmin Ou

Now we add the hand-in-hand ubuntu software install & configuration. We also re-organize the contents. 

CHANGE LOG: Wed Apr 14, 2021, Xu Wang

Now we have migrated the Aliyun ECS to a Tencent Clound VPS, whose ip address is
at `124.156.134.117`. And the port mapping has also been modified, detail can be
found in the mailing list.

---

Contents: 

[toc]

Here are the present stuff maintained:

1. frp
2. webhook
3. go-cqhttp
4. nginx proxy (out of use)
5. Ubuntu basic config
6. Recommended software
7. Slurm work management
8. Prometheus 

## Ubuntu Basic Settings

We need to set the network, ssh service, and firewall to block the unsafe links for convenience and safety concerns. Also, we will introduce intranet penetration for extranet users. 

### Network safety settings

The network of the server is LAN. Thus we need to configure the IP address and DNS of server as follows. 

```yaml
# /etc/netplan/config.yaml
# This is the network config written by 'subiquity'
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    enp5s0:
      dhcp4: no
      addresses: [172.16.2.154/24]
      gateway4: 172.16.2.1
      nameservers:
        addresses: [202.114.64.1]
      routes:
        - to: 0.0.0.0/0
          via: 202.114.64.1
          metric: 300
    enp6s0:
      dhcp4: no
      addresses:
        - 192.168.122.2/24
```

 For network safety, we need to configure the ssh service and firewall. There are some recommendations. 

```
/etc/ssh/sshd_config
# ... Line 15, ssh port to 10000+
Port 31415
# ... Line 35, no permission for root to remote login 
PermitRootLogin no
# ... the last. You are recommended to restrict the admin users' login, which means they should use RSA key to log in. 
Match User runmin
      PasswordAuthentication no
```

To test the ssh configure, use `sshd -t`. If everything's all right, type `sudo systemctl reload sshd` to reload the ssh service.  

Next is the firewall. Ubuntu uses the `iptable` and `ufw` for firewall configuration. 

```shell
$ sudo ufw allow 31415/tcp # allow ssh service above
$ sudo ufw allow from 124.156.134.117 # allow server connection
$ sudo ufw allow from 192.168.122.2 # allow LAN connection - which we connect via wire
$ sudo ufw default deny # deny other connections
$ sudo ufw status numbered # check configuration

Status: inactive

     To                         Action      From
     --                         ------      ----
[ 1] 31416/tcp                  ALLOW IN    Anywhere
[ 2] Anywhere                   ALLOW IN    124.156.134.117
[ 3] Anywhere                   ALLOW IN    192.168.122.2
[ 4] 31416/tcp (v6)             ALLOW IN    Anywhere (v6)
[ 5] Anywhere                   DENY

$ sudo ufw enable # enable the firewall
```



### Intranet Penetration

Now we have 2 server residing in CS building, which are behind the NAT. We call
them __black__ and __white__ respectively. Both using `apt` as their package
management tool.

> You can check the public gateway of Wuhan University using `curl
> http://checkip.amazonaws.com`, and at the time being, it outputs
> `125.220.159.25`. This helps to filter connection from somewhere else.

And also, we have 1 Tencent ECS with public IP address. We refer this as
__transit__. Now it is an Archlinux with `pacman` as its package management
tool. Frp is used to support ssh connection. Now we enabled `frpc.service`
in __black__ and __white__ using `systemd`, so when those two will start frpc
automatically. In __transit__, since it's relatively stable, mannual run it is
somehow fine.

In dir `config`, there are sample configs for frpc/frps. And in
`server/systemd`, there are some unit service files for `systemd` configuration.

The frp client/server should be configured to auto restart since some of our
server might got offline due to accidents. Please refer to `systemd` for more
information.

Please refer to the frp documentation for the detail configuration. You can
check the detailed configuration in our servers.

And also, a dashboard of the servers connection status can be checked at
`http://124.156.134.117:7075`, you need a username and passwd to login in and
check the running status of frp server and clients.

### Server Stuff and Report

Each server has an extra hard disk for backup, and usually, each disk should be
mounted at `/mnt/backup`, you can refer to the backup script in this project dir
/server/cron/bashup.sh for detail. Normally, you should create a `crontab` job
to do the periodical backup task. You should learn more on `cron`.

## Basic Software Installation 

We just show the lists of the basic software for academic use.

1. GPU driver: it should be installed.
2. Anaconda: package managment for python and C++. [Install for all users](https://docs.anaconda.com/anaconda/install/multi-user/)
3. `cgroup`: for user resource restrict. `sudo apt-get install cgroup`
4. `tmux`: terminal multiplexer, allow restore sessions after disconnection. `sudo apt-get install tmux`
5. TBC

## Recommended Softwares

For convience and storage-efficience, we recommend some useful softwares. 

### QQ Group Notification

We use `go-cqhttp` to send messages from __transit__ to our QQ group. Note that
`go-cqhttp` does not support `HTTPS`, we shall always make it listen on
localhost, DO NOT EXPOSE IT IN THE PUBLIC NIC. So how can we send messages to qq
group from __black__ or __white__?


```
At the time being, the gateway for black&white is 125.220.159.25, this helps to
set the filter rule in Aliyun ECS dashboard.
----------------------------------------|
  black   ->|           |               |
            |           |               |
------------|  NGINX  +++>  go-cqhttp   |
  white   ->|           |               ===> Bot Eric in group
            | port 443  |   localhost   |
----------------------------------------|
 github   ->| WEBHOOK ***>  go-cqhttp   |
                                        |
----------------------------------------|
```

Thus we use `curl -k` to connect to nginx proxy and it will help relay the
messages. And in order to protect the Bot qq account, we shall always use auth
token in the http request.

The nginx ssl certificate is not signed by CA, however, it is now just a
self-authorized certificate. We just wont to mask the content of our request for
now, especially the auth token.

You might notice WEBHOOK, it helps to receive webhooks from `github` and execute
a shell script to send event notifications to qq group.

you can config nginx by following this [link](https://www.jianshu.com/p/280de4af8c00) and this [link](https://juejin.cn/post/6881889568297811976).

### Task Management and Scheduling

We use [slurm](https://slurm.schedmd.com/) to manage and schedule the CPU and GPU tasks. Bellow is the fast build for slurm in Ubuntu 20.04 (need 18.04 and newer) based on [this](https://gqqnbig.me/2021/01/27/slurm%E5%8D%95%E6%9C%BA%E6%9C%80%E7%AE%80%E5%AE%89%E8%A3%85%E5%85%A8%E7%90%83%E6%9C%80%E8%AF%A6%E7%BB%86%E6%95%99%E7%A8%8B/#i). 

```shell
# is the commits
$ wget https://gist.github.com/mslacken/4dbef54e55069b51178721cdf1c0107f/raw/d16bb23dd29dd1dacb2a984b32ba34865f355f5b/instant-slurm.sh
$ sudo apt install munge # munge is use for communication between machines (optional)
$ sudo apt install slurm-wlm slurm-wlm-doc -y 
# copy the template file to the /var/slurm-llnl/...
$ sudo mkdir /var/slurm-llnl
$ sudo cp -r $(path_to_slurm_template) /var/slurm-llnl
$ sudo slurmctld -c -D # no saved state (-c) and foreground running (-D)
# fix some bugs (syntax errors like GresType=gpu => Gres=gpu:2) and restart, using:
# $ sudo vim /var/slurm-llnl/slurm.conf
# another terminal
$ sudo slurmd -D  
# another terminal
$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
normal*      up   infinite      1   idle localhost
# if no problems, terminate the slurmctld and slurmd by Ctrl+C
$ sudo systemctl start slurmctld
# fix some bugs (PidFilePath=/var/run/slurmctld.pid) and restart
$ sudo systemctl start slurmd # also some bugs
$ sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
normal*      up   infinite      1   idle localhost
$ srun -n1 --gres=gpu:1 nvidia-smi # test some tasks
$ sudo systemctl enable slurmctld 
$ sudo systemctl enable slurmd
```

Above is the basic function of slurm. Now we prepare the Accounting of slurm.

```shell
$ sudo apt-get install mysql-server
$ sudo apt-get install libmysqlclient-dev # don't know the usage
$ sudo mysql_secure_installation 
# follow instruction of https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04
$ sudo apt install slurmdbd
$ sudo vim /etc/slurm-llnl/slurmdbd.conf
```

>```bash
># /etc/slurm-llnl/slurmdbd.conf
>AuthType=auth/munge
>DbdAddr=localhost
>DbdHost=localhost
>#DbdPort=7031
>SlurmUser=slurm
>#MessageTimeout=300
>DebugLevel=4
>#DefaultQOS=normal,standby
>#LogFile=/var/log/slurm/slurmdbd.log
>PidFile=/var/run/slurmdbd.pid
>#PluginDir=/usr/lib/slurm
>#PrivateData=accounts,users,usage,jobs
>#TrackWCKey=yes
>StorageType=accounting_storage/mysql
>StorageHost=localhost      #mysql所在的服务器
>StoragePort=3306           #端口
>StoragePass=[yourpass]     #登录密码
>StorageUser=slurm          #用户
>StorageLoc=slurm_acct_db 
>```

In /etc/slurm-llnl/slurm.conf, also enable the accounting: 

>```bash
># /etc/slurm-llnl/slurm.conf
># ...
>AccountingStorageType=accounting_storage/slurmdbd
>AccountingStorageUser=slurm
>AccountingStoreJobComment=YES
># ...
>```

Then we could config mysql to create the user 'slurm' and change some config that sutiable for slurmdbd. 

```shell
$ sudo vim /etc/mysql/my.cnf
```

> ```
> # etc/mysql/my.cnf
> ...
> [mysqld]
> innodb_buffer_pool_size=1024M
> innodb_log_file_size=64M
> innodb_lock_wait_timeout=900
> ...
> ```

```shell
$ sudo systemctl restart mysql
$ sudo mysql # or 'mysql -u root -p' if use passwd
mysql> CREATE USER 'slurm'@'localhost' IDENTIFIED BY '[yourpassed]';
mysql> CREATE DATABASE slurm_acct_db;
mysql> GRANT ALL PRIVILEGES ON slurm_acct_db.* TO 'slurm'@'localhost';
mysql> FLUSH PRIVILEGES;
mysql> quit;
$ sudo systemctl start slurmdbd
$ sudo systemctl enable slurmdbd
```

And we could add some account to enable the slurm accounting for some users. 

```shell
$ sudo sacctmgr add cluster jennygroup
Adding Cluster(s)
  Name           = jennygroup
Would you like to commit changes? (You have 30 seconds to decide)
(N/y): y
# other command should be confirm like this. 
$ sudo sacctmgr add account normal Cluster=jennygroup Description="normal accounting" Organization="jennygroup_normal"
$ sudo sacctmgr add user runmin Account=normal
```

Now we can account the added users🥳. Try some submission and have fun using slurm. 

reference: 

1. [Accounting and Resource Limits➲](https://slurm.schedmd.com/archive/slurm-19.05.5/accounting.html)
2. [How To Install MySQL on Ubuntu 20.04➲](https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04)

### Prometheus

We use [Prometheus]() for sever monitoring. We monitor the server and gpu. 

First is the server information monitoring. 

1. Copy the node exporter file `node_exporter` to the /usr/bin/ directory. 
2. Copy the configs/node_exporter.service into the system service. 
3. Adjust the `frpc.ini` file 

Second is the GPU information monitoring. We need to install the Nvidia-container-toolkit:

```shell
$ distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
$ curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
$ curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
$ sudo apt-get update
$ sudo apt-get install -y nvidia-container-toolkit
```

Second, install the nvidia-dcgm, which can be downloaded in [NVIDIA DEVELOPER➲](https://developer.nvidia.com/dcgm#Downloads)

```shell
# download it from ...
$ sudo dpkg -i datacenter-gpu-manager_2.1.4_amd64.deb
$ sudo systemctl enable nvidia-dcgm
$ sudo systemctl start nvidia-dcgm
```

Third, run the dcgm-exporter docker container using `docker run -d --gpus all --rm -p 9400:9400 nvcr.io/nvidia/k8s/dcgm-exporter` . and using `curl localhost:9400/metrics` to verify if it works properly. Restart the `nvidia-dcgm ` if there is nothing. 

Fourth, update the `frpc.ini` asfollows: 

```bash
# /etc/frp/frpc.ini
...
[prometheus_gpu_white]
type = tcp
local_ip = 127.0.0.1
local_port = 9400
remote_port = 9402
...
```

Don't forget to `frpc reload -c /etc/frp/frpc.ini` to reload the frpc service. And also, update the prometheus.yml in the tencent server. the job and targets. 

Note: if you use module in zsh, you should add `source /usr/share/modules/init/zsh` in your ~/.zhsrc

For more, read [GitHub: DCGM-Exporter](https://github.com/NVIDIA/dcgm-exporter)

Third is the slurm exporter, read [GitHub: Prometheus Slurm Exporter](https://github.com/vpenso/prometheus-slurm-exporter) for installation. 