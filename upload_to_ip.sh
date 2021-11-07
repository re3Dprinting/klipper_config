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
  EXTRUDER_FILE="gigabot_extruders.cfg"
  DEV_EXTRUDER_FILE=dev_"$EXTRUDER_FILE"
  TMP="$EXTRUDER_FILE"_tmp
fi

FIRST_THREE_OCTETS="10.1.10."

STEPPER_FILE="gigabot_steppers.cfg"
read -p "Enter Gigabot Size: (1)Regular (2)XLT (3)Terabot (4)Exabot: " model; echo
./get_bedsize.sh $model

if [[ $DEV == "true" ]]
then
  mv $EXTRUDER_FILE $TMP
  cp $DEV_EXTRUDER_FILE $EXTRUDER_FILE
fi 

echo Uploading to IP $FIRST_THREE_OCTETS$1
scp -r {./*.cfg,./*.conf,./get_serial.sh} pi@$FIRST_THREE_OCTETS$1:~/klipper_config/
rm $STEPPER_FILE

if [[ $DEV == "true" ]]
then
  mv $TMP $EXTRUDER_FILE
fi 

ssh pi@$FIRST_THREE_OCTETS$1 "./klipper_config/get_serial.sh"

