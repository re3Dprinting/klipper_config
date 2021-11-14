#!/bin/bash

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [ip] [-d]

Choose which Gigabot uploading config files to
Upload klipper config files to RaspberryPi

Available options:

-h, --help      Print this help and exit
ip		          Last octet of the machine to upload to. Assumes change FIRST_THREE_OCTETS to change ip octet.
-d              Upload development version of klipper_config
EOF
  exit
}

if [[ -z "$1" || $1 == "h" || $1 == "--help" ]]
then
	usage
fi

DEV=""
if [[ -n "$2" && $2 == "-d" ]]
then
  echo Uploading to development pi
  DEV=true
  PRINTER_FILE="printer.cfg"
  echo "[include gigabot_dev.cfg]" >> $PRINTER_FILE
fi

FIRST_THREE_OCTETS="10.1.10."

read -p "Enter Gigabot Size: (1)Regular (2)XLT (3)Terabot (4)Exabot: " model; echo
./get_bedsize.sh $model

echo Uploading to IP $FIRST_THREE_OCTETS$1
scp -r {./*.cfg,./*.conf,./get_serial.sh,./*.cfg.tmpl} pi@$FIRST_THREE_OCTETS$1:~/klipper_config/

if [[ $DEV == "true" ]]
then
  sed -i '$d' $PRINTER_FILE
fi 

ssh pi@$FIRST_THREE_OCTETS$1 "./klipper_config/get_serial.sh"
