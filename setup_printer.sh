#!/bin/bash

set -e 

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") [bedsize] [-d]

-d         Generate a gigabot_dev.cfg file for re:3D's SDK
EOF
  exit
}

if [ -z "$1" ]
then
	usage
fi

./get_bedsize.sh $1
./get_serial.sh

if [[ -n "$2" && $2 == "-d" ]]
then
    echo Setting up for Development Pi
    cp gigabot_dev.cfg.tmpl gigabot_dev.cfg
else
    touch gigabot_dev.cfg
fi
