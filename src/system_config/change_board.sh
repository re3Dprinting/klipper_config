#!/bin/bash

file=/home/pi/printer_data/config/.master.cfg
board=$1
sed -i 's/^board_type=.*/board_type='$board'/' $file