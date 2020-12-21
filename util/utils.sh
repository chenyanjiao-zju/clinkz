#!/bin/bash
#
# To provide the info, error or warning messages utilities, etc.
# 
# Maintainer: Xu Wang (wangxu298@whu.edu.cn)
#
# Sun Dec 5 2020

#######################################
# Check the arch of host
#######################################

#######################################
# check the usability
# return 1 for usable
#######################################
is_installed() {
		local test_command=$1
		if [ command -v ${test_command} &> /dev/null ]; then
				return 1
		else 
				return 0
		fi
}

######################################
# download packages
######################################
get_source() {
		local pkg_to_get=$1
		echo "Now get for ${pkg_to_get}"
		curl -LJ0 ${pkg_to_get} -o ${pkg_to_get##*/}
}

#######################################
# Provide the error infomation.
# Arguments:
#   The error message to print.
#######################################
err() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}


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

