#!/bin/bash
#
# Provide main functionality
#
# Maintainer: Xu Wang (wangxu298@whu.edu.cn)
#
#
. ../util/messages.sh
. ../util/utils.sh

# configure 
group_id=""

# clinkz must not call itself, each subcommand should call the below to forbid.
# there might be more to forbid
disable_recursive_call() {
		if [ $1 = "clinkz" ]; then
				err "clinkz calls itself is forbidden."
				exit 1
		fi
}

dispatch() {
		subcommand=$1
		shift

		if [ ${subcommand} = "notify" ]; then
				job_notify $@
		elif [ ${subcommand} = "restrict" ]; then
				echo "restrict"
		else
				echo "ERR, no such subcommand"
				return
		fi
				
}

main() {
		dispatch $@
}

# notify user when a command is done
# TODO: add time count
# TODO: add AT mapping in group
job_notify() {
		disable_recursive_call $@
		local job=$1
		local user=$(whoami)
		local msg="${job} of user ${user} is to start"
		notify_group ${group_id} ${msg}
		eval $@
		if [ $? -ne 0 ]; then
				msg="${job} of user ${user} failed."
				notify_group ${group_id} ${msg}
				err "${job} failed."
				return
		fi
		msg="${job} of user ${user} is done!"
		notify_group ${group_id} ${msg}
}

# this command is not tested.
# we use cgexec to restrict 
job_restrict() {
		disable_recursive_call $@
		is_installed cgexec
		if [ $? == 1 ]; then
				err "ligcgroup is not installed."
				exit 1
		fi
		local sub_cgroup=$(date | sha1sum)
		sub_cgroup=${sub_cgroup:0-12}
		cgcreate -g memory,cpu:clinkz_cgroup/${sub_cgroup}
		info_msg "sub_cgroup [${sub_cgroup} created.]"
		cgexec -g memory,cpu:clinkz_cgroup/${sub_cgroup} $@
		cgdelete -g memory,cpu:clinkz_cgroup/${sub_cgroup}
		info_msg "sub_cgroup [${sub_cgroup}] deleted."
}

# wrapper for tmux, deprecated.
job_detach() {
		disable_recursive_call $@
		warn_msg "You'd better use Tmux on your own."
		exit 1
		command tmux ls > /dev/null
		if [ $? -ne 0 ]; then 
				new_sess="$(whoami)-temp-session"
				tmux new -s ${new_sess} -d
				tmux neww $@
		else
				tmux neww $@
		fi
}

folder_backup() {
		disable_recursive_call $@
		echo "backup"
}

# the main function
main $@
