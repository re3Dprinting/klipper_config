#!/bin/bash

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [ip]

Upload klipper config files to RaspberryPi

Available options:

-h, --help      Print this help and exit
ip		IP of machine to upload to
EOF
  exit
}

if [ -z "$1" ]
then
	usage
fi

echo Uploading to IP $1
scp base_gigabot.cfg pi@$1:~/printer.cfg  
scp -r gigabot_config pi@$1:~/
