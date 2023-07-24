#!/bin/bash

file=/home/pi/printer_data/config/.master.cfg
crammer=$1
sed -i 's/^crammer_enabled=.*/crammer_enabled='$crammer'/' $file