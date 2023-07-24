#!/bin/bash

file=/home/pi/printer_data/config/.master.cfg
config=$1
sed -i 's/\[.*\]/['$config']/' $file