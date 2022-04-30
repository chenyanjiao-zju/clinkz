#!/bin/bash
# this shell script is used to show the user information, including username, root or not, storage info, expired date, last login date
HostName="tower"
RE_HEAD="UserName\tName\tServer\tUserID\tHomeDir\tShell\tDiskSpace\tLastLogin\tExpireDate\n"
outFile=$2
printf $RE_HEAD > $outFile
for user in $(cut -f 1 $1) 
do
	RE=""
	egrep "^$user" /etc/passwd >& /dev/null
	if [ $? -eq 0 ]
	then
		RE="$(cat $1 | grep "$user")\t$HostName"
		str=$(lslogins -u --output=USER,UID,HOMEDIR,SHELL| grep -E '^'$user$'[ \t]' | sed -e 's/[a-z]*\s*//')
		RE="$RE\t$str"
		userHomeDir=$(echo $str | awk '{print $2}')
		str=$(cat ./infos/info_storage.txt | grep "$userHomeDir" | awk '{print $1}')
		RE="$RE\t$str"
		str=$(lastlog -u "$user" | tail -n 1 | awk '{$1="";$2="";$3="";print $0}')
		str=$(date -d "$str" "+%F-%H:%M")
		RE="$RE\t$str"
		#echo $str
		str=$(sudo chage -l $user | grep "Account expires" | sed -e 's\.*: \\')
		if [ "$str" != "never" ]
		then
			str=$(date -d "$str" "+%F")
		fi
		RE="$RE\t$str"
	fi
	printf "$RE\n" >> $outFile

done

