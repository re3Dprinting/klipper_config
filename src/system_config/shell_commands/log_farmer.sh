#!/bin/bash

cd /home/pi
mkdir debugging_usb
cp -a /home/pi/printer_data/logs/. /home/pi/debugging_usb/
cp /home/pi/klipper_config.log /home/pi/debugging_usb/
mv /home/pi/debugging_usb /media/usb0/debugging_usb

