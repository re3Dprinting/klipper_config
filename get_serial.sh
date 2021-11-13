#!/bin/bash

PWD="$(cd "$(dirname "$0")" && pwd)"
serial=$(ls /dev/serial/by-id/* 2>/dev/null)
if [ $? -ne 0 ] 
then
    echo "Please plug in Gigabot USB"
    exit 1
fi

SERIAL_LINE='serial: .*'
NEW_SERIAL_LINE="serial: $serial"
sed -i --expression "s|$SERIAL_LINE|$NEW_SERIAL_LINE|g" $PWD/gigabot_mcu.cfg
