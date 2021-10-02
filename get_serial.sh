#!/bin/bash

serial=$(ls /dev/serial/by-id/* 2>/dev/null)
if [ $? -ne 0 ] 
then
    echo "Please plug in Gigabot USB"
    exit 1
fi

prefix=$'[mcu]\nserial: '
echo "$prefix"$serial > gigabot_serial.cfg

# echo $serial