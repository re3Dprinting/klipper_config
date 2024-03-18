#!/bin/bash

cd /home/pi/klipper/
sudo make clean
sudo service klipper stop
make flash FLASH_DEVICE=/dev/serial/by-id/usb-03eb_6124-if00
sudo service klipper start
sudo systemctl disable flash_firmware.service
sudo reboot