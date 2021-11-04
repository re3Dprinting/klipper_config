#!/bin/bash

PWD="$(cd "$(dirname "$0")" && pwd)"
serial=$(ls /dev/serial/by-id/* 2>/dev/null)
if [ $? -ne 0 ] 
then
    echo "Please plug in Gigabot USB"
    exit 1
fi

GIGABOT_SERIAL_VAR='{gigabot_serial}'
sed -ie "s|$GIGABOT_SERIAL_VAR|$serial|g" $PWD/gigabot_mcu.cfg
