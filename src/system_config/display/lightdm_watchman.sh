#!/bin/bash

while true;
do
    sleep 5s
	if grep -q "Error connecting to XServer" /var/log/lightdm/lightdm.log
	then
		echo "Restart Display after Error"    
		service lightdm restart
	else
		echo "Display is allready running"
		exit 0
	fi
done
