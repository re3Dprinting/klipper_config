#!/bin/bash 

PWD="$(cd "$(dirname "$0")" && pwd)"

# Check if a usb is plugged in
# Check if the usb matches Klipper regex
# flash and reboot if it doesnt match


export LC_ALL=C
cp $PWD/.config $HOME/klipper/.config
$PWD/upload_firmware.exp