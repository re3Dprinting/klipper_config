#!/bin/bash

PWD="$(cd "$(dirname "$0")" && pwd)"

if [[ -n "$1" && $1 == "-uart" ]]
then
    echo Using UART for com
    serial="/dev/ttyAMA0"
    # Need to append "restart_method: command" as well.
else
    serial=$(ls /dev/serial/by-id/* 2>/dev/null)
    if [ $? -ne 0 ] 
    then
        echo "Please plug in Gigabot USB"
        exit 1
    fi
fi

SERIAL_LINE='serial: .*'
NEW_SERIAL_LINE="serial: $serial"
sed --expression "s|$SERIAL_LINE|$NEW_SERIAL_LINE|g" $PWD/gigabot_mcu.cfg.tmpl > $PWD/gigabot_mcu.cfg
