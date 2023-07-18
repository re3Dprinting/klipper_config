#!/bin/bash

file=/home/pi/test_master.cfg
config=$1
sed -i 's/\[.*\]/['$config']/' $file