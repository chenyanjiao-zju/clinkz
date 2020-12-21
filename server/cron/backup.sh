#!/bin/bash
#
# Provide daily/weekly backup utility for server via rsync. Note that backups
# are not recommended to execute too often.
# Since user ww is a legacy user, we do not backup it in script but to mannually
# backup it.
#
# Maintainer: Xu Wang (wangxu298@whu.edu.cn)
#
# TODO: snapshot backup
# TODO: add exclude option to save disk space

set -e

MYSECRECT=
MYGROUP=
# we backup data to /mnt/backup
# check the backup disk is mounted, we wont allow script to mount a filesystem
findmnt -rno SOURCE,TARGET "/mnt/backup"
if [ $? -ne 0 ]; then
    echo "The backup disk is not mounted at /mnt/backup"
    exit 1
fi

# notify in group
local_now=$(date +'%Y-%m-%dT%H:%M:%S')
local_host=$(uname -n)
if [ $local_host = "ww-X299-UD4" ]; then
    machine="White"
elif [ $local_host = "chenyanjiao-System" ]; then
    machine="Black"
else
    machine=$local_host
fi
curl -k -v  \
         -G --data-urlencode "access_token=$MYSECRECT"  \
         --data-urlencode "group_id=$MYGROUP"  \
         --data-urlencode "message=[${local_now}] $machine server start backup." \
         https://47.115.92.165:443/send_group_msg

for file in /home/* ; do
	if [ -d ${file} ] && [ ${file} != "/home/ww" ]; then
		echo "$(date) Now backup for ${file}"
		rsync -a --delete ${file} /mnt/backup &> /dev/null
	fi
done
curl -k -v  \
         -G --data-urlencode "access_token=$MYSECRECT"  \
         --data-urlencode "group_id=$MYGROUP"  \
         --data-urlencode "message=[${local_now}] $machine server done backup." \
         https://47.115.92.165:443/send_group_msg
