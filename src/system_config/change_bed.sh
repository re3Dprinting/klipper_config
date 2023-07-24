#!/bin/bash

file=/home/pi/printer_data/config/.master.cfg
bed=$1
sed -i 's/^heater_bed_enabled=.*/heater_bed_enabled='$bed'/' $file