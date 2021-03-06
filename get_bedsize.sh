#!/bin/bash

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") [bedsize]

Enter the following to create a gigabot_stepper.cfg file for sizes:
    1) Regular
    2) XLT
    3) Terabot
    4) Exabot
EOF
  exit
}

if [ -z "$1" ]
then
	usage
fi


REPLACE_FILE=""
NEW_FILE="bot_flavor.cfg"

case $1 in
  1) #Regular
    echo "Setting up for Gigabot Regular..."
    REPLACE_FILE="bot_flavors/gigabot.cfg.tmpl";;
  2) #XLT
    echo "Setting up for Gigabot XLT..."
    REPLACE_FILE="bot_flavors/gigabotXLT.cfg.tmpl";;
  3) #Terabot
    echo "Setting up for Gigabot Terabot..."
    REPLACE_FILE="bot_flavors/terabot.cfg.tmpl";;
  4) #Exabot
    echo Exabot current unavailable.; exit 1;;
  *)
    usage; exit 1;;
esac

cat "$REPLACE_FILE" > "$NEW_FILE"