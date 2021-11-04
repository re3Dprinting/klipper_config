#!/bin/bash

serial=$(ls /dev/serial/by-id/* 2>/dev/null)
if [ $? -ne 0 ] 
then
    echo "Please plug in Gigabot USB"
    exit 1
fi

GIGABOT_SERIAL_VAR='{gigabot_serial}'
sed -i "s/$GIGABOT_SERIAL_VAR/serial/g" gigabot_mcu.cfg
