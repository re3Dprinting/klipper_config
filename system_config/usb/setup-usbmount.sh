#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

PWD="$(cd "$(dirname "$0")" && pwd)"
apt-get install usbmount -y

# Set up the scripts that configure the 'usbmount' package, which will
# mount any recognized filesystem when a USB thumb drive is inserted.
cp $PWD/usbmount.conf /etc/usbmount/usbmount.conf
cp $PWD/00_create_model_symlink /etc/usbmount/mount.d/
cp $PWD/00_remove_model_symlink /etc/usbmount/umount.d/

chown root:root /etc/usbmount/mount.d/00_create_model_symlink
chown root:root /etc/usbmount/umount.d/00_remove_model_symlink 

chown 755 /etc/usbmount/mount.d/00_create_model_symlink
chmod 755 /etc/usbmount/umount.d/00_remove_model_symlink
chmod 644 /etc/usbmount/usbmount.conf

#Set PrivateMount to No in systemd-udevd.service
cp $PWD/systemd-udevd.service /lib/systemd/system/systemd-udevd.service
chmod 644 /lib/systemd/system/systemd-udevd.service

# We are going to mount the usb to the ~/gcode_files file of klipper.