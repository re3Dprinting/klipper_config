#!/bin/bash

mount -tvfat -osync,noexec,nodev,noatime,nodiratime,nosuid,fmask=0,dmask=0 /dev/sda1 /media/usb0
