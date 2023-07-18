#!/bin/bash

file=/home/pi/test_master.cfg
board=$1
sed -i 's/^board_type=.*/board_type='$board'/' $file