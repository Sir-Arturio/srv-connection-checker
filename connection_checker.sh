### Init ###
status_file='/tmp/conection_status'
if [ ! -f $status_file ]
then
	echo "Status file does not exist. System restarted?"
	echo 'unspecified' > $status_file
fi

prev_status=$(head -1 $status_file >&1)
date_stamp=$(date '+[%Y-%m-%d %H:%M:%S]' >&1)


### Action ###
output=$(wget --timeout=5 --spider http://192.168.0.253 2>&1)
if [ $? -eq 0 ]
then
	echo "Connection up."
	if [ ${prev_status:-unspecified} != 'up' ]
	then
		echo "Status change: CONNECTED"
	fi
	echo 'up' > $status_file
else
	echo "Connection down."
	if [ ${prev_status:-unspecified} != 'down' ]
	then
		echo "Status change: DISCONNECTED"
	fi
	echo 'down' > $status_file
fi

