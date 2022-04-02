#!/bin/bash

PWD="$(cd "$(dirname "$0")" && pwd)"
KLIPPER_CONFIG_PWD=$PWD/..
TMPL_PWD=$KLIPPER_CONFIG_PWD/templates

if [[ -n "$1" && $1 == "-uart" ]]
then
    echo Using UART for com
    serial="/dev/ttyAMA0"
    # Need to append "restart_method: command" as well.
else
    serial=$(ls /dev/serial/by-id/* 2>/dev/null)
    if [ $? -ne 0 ] 
    then
        echo "No Gigabot Serial Detected, skipping..."
        exit 0
    fi
fi

SERIAL_LINE='serial: .*'
NEW_SERIAL_LINE="serial: $serial"
sed --expression "s|$SERIAL_LINE|$NEW_SERIAL_LINE|g" $TMPL_PWD/serial.cfg > $KLIPPER_CONFIG_PWD/_serial.cfg
