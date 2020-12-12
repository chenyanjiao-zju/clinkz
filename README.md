# Clinkz

`Clinkz` is a loose integration of tools to improve the work flow of lab stuff.
Written in shell script, its target is not to achieve high performance or
carefully designed, but to be practical.

It is an integration of some awesome tools, including:

1. [frp](https://github.com/fatedier/frp)
2. [go-cqhttp](https://github.com/Mrs4s/go-cqhttp)
3. [webhook](https://github.com/adnanh/webhook) & GitHub webhooks

`Clinkz` incorporates two parts: ones to provide wrapper for jobs to run at
server, and in this part we introduce `clinkz`, a helper to achieve some
functionalities such like job notification and schedule. The other is the
utility of server access, management and remote code host platform (GitHub)
		notification. This part is for the server administrator. 

To better integrate, you are welcome to create a golang version, contact me if
you want to.

---

## `clinkz` command

`clinkz` is the shell script utility for managing the stuff for servers in our 
lab, in order to improve the efficiency of server maintaining.

### Usage

`clinkz $SUBCOMMAND YOUR_COMMAND [OPTIONS]`

For example, to enable job notification:
```shell
# e.g. we want to init a job to sleep for 10 secs
sleep 10
# use clinkz to enable notification when sleep is done
clinkz notify sleep 10
```
Then, after about 10 secs, we shall receive the notification of job done in our
developer's QQ group.

Now `clinkz` supports the subcommands below:

- `notify`: job notification, please do not abuse job notification since it
sends group msg rather than private msg.
- `restrict`: some calculation job consumes massive CPU resources such as
MatLab, which might cause server to crash. So we shall limit the job/process
resource via `cgroup`.

TBD:
- `schedule`: You can schedule your job to run at a specified time, e.g. at the
midnight.
- `rsync`": help you backup your folder.
- `recover`: help you recover your folder.

### Internal

Refer to next section.

---

## Server Access and Management for Dev

To begin with, we have two servers (white and black) in our lab and an Aliyun
ECS with public IP address to serve as relay node.

This part has several tools to configure:

### frp, the intranet peneration tool
We provide the remote access via ssh for developers. And in order to start the
service when boot/reboot the server, we add the __frpc.service__ to enable frpc
service. See more in the `doc/for-admin.md`

Thus via frp, we can access the server which resides in a LAN:

```shell
# contact the admin for infomation
# REMOTE_PORT distincts the server, USER_NAME refers to your login user, and the
# ip x.x.x.x is the relay node configured by admin (current the Aliyun ECS)
ssh -oPort=REMOTE_PORT USER_NAME@x.x.x.x
```

Normally, the admin only gives you the username and password. You ought to
configure something like default shell, STH-YOU-LIKE.rc, and the admin would not
add you to the `sudo` user group by default.

### go-cqhttp, the tool for QQ group
All notifications are sent by go-cqhttp, and this server is on Aliyun ECS.

go-cqhttp provides a http server, expects `GET` requests with args, and send
messages to the QQ group. Since runnin in a public environment, we shall not
expose the service and just make it listening on a port in localhost, until
go-cqhttp have added the HTTPS support.

See more in `doc/for-admin.md`.

### webhook
The tool to handle GitHub webhooks and relay notifications to QQ group via
go-cqhttp. 

See more in `doc/for-admin.md`.

### server backup
The admin backups your $HOME periodically.
