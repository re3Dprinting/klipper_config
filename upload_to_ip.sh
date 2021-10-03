#!/bin/bash

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [ip]

Upload klipper config files to RaspberryPi

Available options:

-h, --help      Print this help and exit
ip		Last octet of the machine to upload to. Assumes 192.168.1.XX
EOF
  exit
}

if [ -z "$1" ]
then
	usage
fi

echo Uploading to IP 192.168.1.$1
scp -r {./*.cfg,./*.conf,./get_serial.sh} pi@192.168.1.$1:~/klipper_config/
