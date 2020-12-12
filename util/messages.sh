#!/bin/bash
#
# Provide uniform message utils for notification.
#
# Maintainer: Xu Wang (wangxu298@whu.edu.cn)
#
# Sun Dec 6 2020


#######################################
# cofig
host="127.0.0.1:5700"
#######################################
# Message templates for notification
#######################################
info_msg() {
		echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')][INFO]:$1"
}

warn_msg() {
		echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')][WARNING]:$1"
}

error_msg() {
		echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')][ERROR]:$1"
}

#######################################
# Send message to group via go-cqhttp
# Arguments:
#		group_id
# Returns:
#   None
#######################################
notify_group() {
		local id=$1
		shift
		local msg="[CQ:at,qq=all][$(date +'%Y-%m-%dT%H:%M:%S%z')] $*"
		curl \
				--data-urlencode "group_id=${id}" \
				--data-urlencode "message=${msg}" \
				"http://${host}/send_group_msg"
}

warn_group() {
		local id=$1
}


