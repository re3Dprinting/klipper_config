#!/bin/bash

cd /home/pi/
mkdir debugging
cd /home/pi/debugging/
cp /home/pi/printer_data/logs/klippy.log .
/home/pi/klipper/scripts/logextract.py  ./klippy.log
cd /home/pi/
sudo rm -rf /home/pi/printer_data/config/debugging
sudo mv /home/pi/debugging /home/pi/printer_data/config/debugging
/home/pi/klipper/scripts/graphstats.py /home/pi/printer_data/logs/klippy.log -o /home/pi/printer_data/config/debugging/loadgraph.png
$echo "Debug information has been generated in the 'Debugging' folder in the configuration files"