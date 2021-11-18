#!/bin/bash

set -e 

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") [bedsize] [-d] [-uart]

-d         Generate a gigabot_dev.cfg file for re:3D's SDK
-uart      Use uart instead of USB for communication
EOF
  exit
}

if [ -z "$1" ]
then
	usage
fi

PWD="$(cd "$(dirname "$0")" && pwd)"
TMPL_PWD=$PWD/templates

$PWD/get_bedsize.sh $1

if [[ -n "$2" && $2 == "-d" ]]
then
    echo Setting up for Development Pi
    cp $TMPL_PWD/gigabot_dev.cfg.tmpl $PWD/gigabot_dev.cfg
else
    touch $PWD/gigabot_dev.cfg
fi

if [[ -n "$2" && $2 == "-uart" ]]
then
    $PWD/get_serial.sh -uart
else
    $PWD/get_serial.sh
fi

if [[ ! -f $PWD/gigabot_save_variables.cfg ]]
then
    cp $TMPL_PWD/gigabot_save_variables.cfg.tmpl $PWD/gigabot_save_variables.cfg
fi
