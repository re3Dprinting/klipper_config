#!/bin/bash

cd /home/pi
mkdir debugging
cp -a /home/pi/printer_data/logs/. /home/pi/debugging/
cp /home/pi/klipper_config.log /home/pi/debugging/

