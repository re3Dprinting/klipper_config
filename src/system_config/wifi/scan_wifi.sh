#!/bin/bash

iw wlan0 scan | grep -Po '(signal|SSID):\K.*' | sed 's/ $/ [unknown SSID]/' | paste -d ' ' - - | cut -c2- | sort -gr > /home/pi/klipper_config/wifi_networks 2>&1
