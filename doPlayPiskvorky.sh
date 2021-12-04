#!/bin/bash

while true
do
	if [[ -f "$( dirname "$( realpath "${0}" )" )/STOP" ]]
	then
		echo "Stopped, waiting..."
		sleep 300
		continue
	fi
	
	sleep 1
	bash "$( dirname "$( realpath "${0}" )" )/play.sh"
done
