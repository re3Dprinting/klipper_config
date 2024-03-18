#!/bin/bash

mv announcement_start.sh announcement.sh check_updates.sh debug.sh flash_firmware.sh integrate.sh mac_network.sh /usr/local/bin/
mv shell_command.cfg /home/pi/printer_data/config/
chown pi:pi /usr/local/bin/announcement_start.sh /usr/local/bin/announcement.sh /usr/local/bin/check_updates.sh /usr/local/bin/debug.sh /usr/local/bin/flash_firmware.sh /usr/local/bin/integrate.sh /usr/local/bin/mac_network.sh
chmod +x /usr/local/bin/announcement_start.sh /usr/local/bin/announcement.sh /usr/local/bin/check_updates.sh /usr/local/bin/debug.sh /usr/local/bin/flash_firmware.sh /usr/local/bin/integrate.sh /usr/local/bin/mac_network.sh
