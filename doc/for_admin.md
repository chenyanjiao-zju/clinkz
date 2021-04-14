# For administrator

Thank you for maintaining the server!

---
CHANGE LOG: Wed Apr 14, 2021, Xu Wang

Now we have migrated the Aliyun ECS to a Tencent Clound VPS, whose ip address is
at `124.156.134.117`. And the port mapping has also been modified, detail can be
found in the mailing list.

---

Here are the present stuff maintained:

1. frp
2. webhook (out of use)
3. go-cqhttp (out of use)
4. nginx proxy (out of use)

But we'd like to talk from the functionality perspective:

## Intranet Penetration

Now we have 2 server residing in CS building, which are behind the NAT. We call
them __black__ and __white__ respectively. Both using `apt` as their package
management tool.

> You can check the public gateway of Wuhan University using `curl
> http://checkip.amazonaws.com`, and at the time being, it outputs
> `125.220.159.25`. This helps to filter connection from somewhere else.

And also, we have 1 Aliyun ECS with public IP address. We refer this as
__transit__. Now it is an Archlinux with `pacman` as its package management
tool. Frp is used to support ssh connection. Now we enabled `frpc.service`
in __black__ and __white__ using `systemd`, so when those two will start frpc
automatically. In __transit__, since it's relatively stable, mannual run it is
somehow fine.

> [INFO] Now the Aliyun ECS has been replaced by a Tencent VPS, running Ubuntu 20.04.

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

## QQ Group Notification (Now out of maintain)

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

## Server Stuff and Report

Each server has an extra hard disk for backup, and usually each disk should be
mounted at `/mnt/backup`, you can refer to the backup script in this project dir
/server/cron/bashup.sh for detail. Normally, you should create a `crontab` job
to do the periodical backup task. You should learn more on `cron`.


