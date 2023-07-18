#!/bin/bash

cd ~/klipper/
make
sleep 30
cd
ls /dev/serial/by-id