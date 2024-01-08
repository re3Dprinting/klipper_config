#!/bin/bash

PWD="$(cd "$(dirname "$0")" && pwd)"
KLIPPER_CONFIG_PWD=$PWD/..
TMPL_PWD=$PWD/common

AZTEEG_SERIAL="usb-FTDI_FT"
ARCHIM_SERIAL="Klipper_sam3x8e"
serial=$(ls /dev/serial/by-id/* 2>/dev/null)
echo "Detected serial: $serial"
SERIAL_LINE='serial: .*'
NEW_SERIAL_LINE="serial: $serial"
sed --expression "s|$SERIAL_LINE|$NEW_SERIAL_LINE|g" $TMPL_PWD/serial.cfg > $KLIPPER_CONFIG_PWD/build/_serial.cfg
