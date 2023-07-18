#!/bin/bash

file=/home/pi/test_master.cfg
platform=$1
sed -i 's/^platform_type=.*/platform_type='$platform'/' $file