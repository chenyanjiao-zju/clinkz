# For administrator

Thank you for maintaining the server!

Here are the present stuff maintained:

1. frp
2. webhook
3. go-cqhttp
4. nginx proxy

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

In dir `config`, there are sample configs for frpc/frps. And in
`server/systemd`, there are some unit service files for `systemd` configuration.


## QQ Group Notification

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

TODO.

