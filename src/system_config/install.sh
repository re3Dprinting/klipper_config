#!/bin/bash 

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}")
EOF
  exit
}

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

PWD="$(cd "$(dirname "$0")" && pwd)"
HOME=$PWD/../../..

function check_and_overwrite {
    overwrite_file=$1
    new_file=$2 
    if cmp $new_file $overwrite_file; then
        echo "$new_file and $overwrite_file are the same, skipping..."
    else
        echo "overwriting $overwrite_file"
        cp $new_file $overwrite_file
    fi
}

# System Setup

BOOT_PATH="/boot"
# Display KMS setup
check_and_overwrite $BOOT_PATH/config.txt $PWD/config.txt
check_and_overwrite $BOOT_PATH/fullpageos.txt $PWD/fullpageos.txt
check_and_overwrite $BOOT_PATH/splash.png $PWD/splash.png
#Stop logging over serial
sed -i "s/console=serial0,115200//g" $BOOT_PATH/cmdline.txt 

LIGHTDM_CONFIG_PATH="/etc/lightdm"
# Enable xrandr script on boot
check_and_overwrite $LIGHTDM_CONFIG_PATH/lightdm.conf $PWD/lightdm.conf
# Disable Cursor
check_and_overwrite "/usr/share/lightdm/lightdm.conf.d/01_debian.conf" $PWD/01_debian.conf

FULLPAGEOS_SCRIPT_PATH="$HOME/scripts"
check_and_overwrite $FULLPAGEOS_SCRIPT_PATH/start_chromium_browser $PWD/start_chromium_browser

# Fluidd + Moonraker + Klipper Installation 
sudo -i -u pi bash << EOF
whoami
cd $HOME
if [ ! -d "$HOME/kiauh" ] ; then
    git clone https://github.com/plloppii/kiauh.git
fi
if [ ! -d "$HOME/virtual_keyboard" ] ; then
    git clone https://github.com/re3Dprinting/virtual_keyboard.git
fi

# Reset to a particular hash for kiauh so future commits do not break exp script
cd $HOME/kiauh
git reset --hard dd58229fee250ffdc7a08b3b0b245fa4ffda8ea0

cd $PWD
./install_klipper.exp
./install_moonraker.exp
./install_mainsail.exp

cp ./moonraker_secrets.ini $HOME

cd $HOME/moonraker/scripts
./set-policykit-rules.sh

cd $HOME/klipper
git remote set-url origin https://github.com/re3Dprinting/klipper.git
git pull
git reset --hard origin/master

cd $HOME/moonraker
git remote set-url origin https://github.com/re3Dprinting/moonraker.git
git pull
git reset --hard origin/master

# Initial run of setup_printer.py to generate .master.cfg file
cd $HOME/klipper_config
./src/setup_printer.py
EOF

#Install os packages
apt-get install xinput ripgrep nmap python3-pip xscreensaver* -y

#Install python packages
pip3 install GitPython

#Set up usbmount service
bash $PWD/usb/setup-usbmount.sh

#Use saved xscreensaver config to point to screensaver image
cp $PWD/screensaver/.xscreensaver $HOME

#Set up lightdm_watchman service
sudo cp $PWD/display/lightdm_watchman.service /etc/systemd/system/lightdm_watchman.service
sudo chmod 644 /etc/systemd/system/lightdm_watchman.service
sudo systemctl enable lightdm_watchman.service

#Set up wifi scanning service 
sudo cp $PWD/wifi/scan_wifi.service /etc/systemd/system/scan_wifi.service
sudo chmod 644 /etc/systemd/system/scan_wifi.service
sudo systemctl enable scan_wifi.service

#Set up klipper_config as a service
sudo cp $PWD/klipper/klipper_config.service /etc/systemd/system/klipper_config.service
sudo chmod 644 /etc/systemd/system/klipper_config.service
sudo systemctl enable klipper_config.service

reboot
