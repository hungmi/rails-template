#!/bin/bash

#trap 'echo $BASH_COMMAND' DEBUG

LINE=30

while getopts ":n:" option
do
	case $option in
		n)
			echo "n= $OPTARG"
			LINE="$OPTARG"
			;;
	esac
done

echo $LINE

ssh -i ~/.ssh/<%= @private_ssh_key %> deploy@<%= @server_ip %> tail -f /home/deploy/<%= app_name %>/shared/log/production.log -n $LINE
