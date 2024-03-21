#!/bin/bash

TIMESTAMP=$(date)
file=/home/pi
hostnamectl set-hostname "$1"
echo "Hostname has been changed to: $1  - Interface will now connect with: $1.local - System needs to reboot for cha$
echo "Timestamp: $TIMESTAMP" >> $file/shell_log.txt
echo "Hostname has been changed to: $1" >> $file/shell_log.txt
echo "" >> $file/shell_log.txt
