#!/bin/bash

# Define variables
home=/home/pi
config=$home/printer_data/config
sys_path=$config/src/system_config
config_files=("standalone.cfg" "crowsnest.conf" "timelapse.cfg" ".master.cfg")

# Update and upgrade system
sudo apt update
sudo apt upgrade -y

# Pull latest changes from git
cd $home/klipper_config/
git pull
cd $home

# Backup config
rm -rf $home/configBKP
mkdir $home/configBKP
chown pi:pi $home/configBKP
cp -a $config/. $home/configBKP/

# Move config files to temporary location
for file in "${config_files[@]}"; do
    mv $config/$file $home/${file}TMP
done

# Replace config with latest from git
rm -rf $config
cp -a $home/klipper_config/. $config/

# Move config files back from temporary location
for file in "${config_files[@]}"; do
    mv $home/${file}TMP $config/$file
    chown pi:pi $config/$file
done
bash $sys_path/shell_commands/shell_setup.sh
# Refresh display
sleep 1
export DISPLAY=:0
export XAUTHORITY=/home/pi/.Xauthority
xdotool key F5
reboot