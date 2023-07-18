#!/bin/bash

file=/home/pi/test_master.cfg
bed=$1
sed -i 's/^heater_bed_enabled=.*/heater_bed_enabled='$bed'/' $file