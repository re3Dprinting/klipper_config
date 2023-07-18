#!/bin/bash

file=/home/pi/test_master.cfg
crammer=$1
sed -i 's/^crammer_enabled=.*/crammer_enabled='$crammer'/' $file