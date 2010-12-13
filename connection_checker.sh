### Init ###
status_file='/tmp/conection_status'
log_file='/var/log/connection_status/connection_status.log'
date_stamp=$(date '+[%Y-%m-%d %H:%M:%S]' >&1)
if [ ! -f $status_file ]
then
	echo "${date_stamp} Status file does not exist. System restarted?" >> $log_file
	echo 'unspecified' > $status_file
fi

prev_status=$(head -1 $status_file >&1)


### Action ###
output=$(wget --timeout=5 --spider http://www.google.com 2>&1)
if [ $? -eq 0 ]
then
	echo "Connection up."
	if [ ${prev_status:-unspecified} != 'up' ]
	then
		echo "${date_stamp} Status change: CONNECTED" >> $log_file
	fi
	echo 'up' > $status_file
else
	echo "Connection down."
	if [ ${prev_status:-unspecified} != 'down' ]
	then
		echo "${date_stamp} Status change: DISCONNECTED" >> $log_file
	fi
	echo 'down' > $status_file
fi

