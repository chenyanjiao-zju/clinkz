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

for file in /home/* ; do
		if [ -d ${file} ] && [ ${file} != "/home/ww" ]; then
				echo "$(date) Now backup for ${file}"
				rsync -a --delete ${file} /mnt/backup &> /dev/null
		fi
done
