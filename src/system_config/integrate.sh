#!/bin/bash

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}")
EOF
  exit
}

if [ "$EUID" -ne 0 ]
  then echo "Please run as root, try: sudo ./integrate.sh"
  exit
fi

PWD="$(CD "$(dirname "$0")" && pwd)"
HOME=~PWD/../../..

cd $HOME
mkdir $HOME/config_backup/
cp -a $HOME/printer_data/config/. $HOME/config_backup/
mv $HOME/printer_data/config/standalone.cfg $HOME/standaloneBKP.cfg
rm -rf $HOME/printer_data/config
cp -a $HOME/klipper_config/. $HOME/printer_data/config
rm $HOME/printer_data/config/standalone.cfg
mv $HOME/standaloneBKP.cfg $HOME/printer_data/config/standalone.cfg

