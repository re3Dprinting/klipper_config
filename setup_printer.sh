#!/bin/bash

set -e 

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") [-b bedsize] [-d | -uart | -internal]

[-b bedsize]
    Enter the following to create a gigabot_stepper.cfg file for sizes:
    1) Regular
    2) XLT
    3) Terabot
    4) Exabot

[-d | -uart | -internal]
    -d         Generate a gigabot_dev.cfg file for re:3D's SDK
    -uart      Use uart instead of USB for communication
    -internal  Set up mainsail to point to web_beta (Prerelease)
EOF
  exit
}

if [ -z "$1" ]
then
	usage
fi

PWD="$(cd "$(dirname "$0")" && pwd)"
HOME=$PWD/..
TMPL_PWD=$PWD/templates

function add_tmpl_if_not_exist {
    tmpl_file=$1
    file_to_add=$2 
    if [[ ! -f $2 ]]; then
        echo "$file_to_add does not exist, adding..."
        cp $1 $2
    else
        echo "$2 exists, skipping..."
    fi
}

while getopts b:uid opts; do
   case ${opts} in
      b) PLATFORM=${OPTARG} ;;
      u) UART="-uart" ;;
      i) INTERNAL="TRUE" ;;
      d) DEV="TRUE" ;;
   esac
done

$PWD/get_bedsize.sh $PLATFORM

if [[ $DEV == "TRUE" ]]
then
    echo Setting up for Development Pi
    cp $TMPL_PWD/gigabot_dev.cfg.tmpl $PWD/gigabot_dev.cfg
else
    echo "" > $PWD/gigabot_dev.cfg
fi

$PWD/get_serial.sh $UART

add_tmpl_if_not_exist $TMPL_PWD/gigabot_save_variables.cfg.tmpl $PWD/gigabot_save_variables.cfg
add_tmpl_if_not_exist $TMPL_PWD/gigabot_standalone_config.cfg.tmpl $PWD/gigabot_standalone_config.cfg

cp $TMPL_PWD/moonraker.conf.tmpl $PWD/moonraker.conf
