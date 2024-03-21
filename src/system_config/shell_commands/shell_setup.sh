#!/bin/bash
cd /home/pi/printer_data/config/src/system_config/shell_commands/
mv announcement_start.sh announcement.sh check_updates.sh debug.sh flash_firmware.sh integrate.sh mac_network.sh change_configuration.sh reboot.sh unmount_usb.sh mount_usb.sh log_farmer.sh change_hostname.sh /usr/local/bin/
mv shell_command.cfg /home/pi/printer_data/config/
chown pi:pi /usr/local/bin/announcement_start.sh /usr/local/bin/announcement.sh /usr/local/bin/check_updates.sh /usr/local/bin/debug.sh /usr/local/bin/flash_firmware.sh /usr/local/bin/integrate.sh /usr/local/bin/mac_network.sh /usr/local/bin/flash_firmware.sh /usr/local/bin/integrate.sh /usr/local/bin/mac_network.sh /usr/local/bin/change_configuration.sh /usr/local/bin/reboot.sh /usr/local/bin/unmount_usb.sh /usr/local/bin/mount_usb.sh /usr/local/bin/log_farmer.sh /usr/local/bin/change_hostname.sh
chmod +x /usr/local/bin/announcement_start.sh /usr/local/bin/announcement.sh /usr/local/bin/check_updates.sh /usr/local/bin/debug.sh /usr/local/bin/flash_firmware.sh /usr/local/bin/integrate.sh /usr/local/bin/mac_network.sh /usr/local/bin/flash_firmware.sh /usr/local/bin/integrate.sh /usr/local/bin/mac_network.sh /usr/local/bin/change_configuration.sh /usr/local/bin/reboot.sh /usr/local/bin/unmount_usb.sh /usr/local/bin/mount_usb.sh /usr/local/bin/log_farmer.sh /usr/local/bin/change_hostname.sh