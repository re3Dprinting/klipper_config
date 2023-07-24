#!/bin/bash

file=/home/pi/printer_data/config/.master.cfg
platform=$1
sed -i 's/^platform_type=.*/platform_type='$platform'/' $file