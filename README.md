# Clinkz

`Clinkz` is a loose integration of tools to improve the work flow of lab stuff.
Written in shell script, its target is not to achieve high performance or
carefully designed, but to be practical.

It is an integration of some awesome tools, including:

1. [frp](https://github.com/fatedier/frp)
2. [go-cqhttp](https://github.com/Mrs4s/go-cqhttp)
3. [webhook](https://github.com/adnanh/webhook) & GitHub webhooks
4. [slurm](https://www.schedmd.com) TODO

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

### slurm
`slurm` (simple linux utility for resource management) is a free software which
has been adopted by many supercomputing platform and key labs, developed by
LLNL. We use it for job schedule and queuing.

See more in `doc/for-admin.md`.

### server backup
The admin backups your $HOME periodically.
