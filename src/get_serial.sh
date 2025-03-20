#!/bin/bash

PWD="$(cd "$(dirname "$0")" && pwd)"
KLIPPER_CONFIG_PWD=$PWD/..
TMPL_PWD=$PWD/common

AZTEEG_SERIAL="usb-FTDI_FT"
ARCHIM_SERIAL="Klipper_sam3x8e"
BEACON_SERIAL="usb-Beacon_Beacon"

# Get all serial devices
serial_devices=$(ls /dev/serial/by-id/* 2>/dev/null)
echo "Detected serial devices: $serial_devices"

# Find printer board serial
printer_serial=$(echo "$serial_devices" | grep -E "$AZTEEG_SERIAL|$ARCHIM_SERIAL")
# Find beacon serial
beacon_serial=$(echo "$serial_devices" | grep "$BEACON_SERIAL")

# Update printer serial in config using the placeholder
sed "s|{gigabot_serial}|$printer_serial|g" $TMPL_PWD/serial.cfg > $KLIPPER_CONFIG_PWD/build/_serial.cfg

# If beacon is detected, create or update beacon config
if [ ! -z "$beacon_serial" ]; then
    echo "Beacon detected: $beacon_serial"
    sed --expression "s|serial:|serial: $beacon_serial|g" $TMPL_PWD/beacon.cfg > $KLIPPER_CONFIG_PWD/build/_beacon.cfg
fi