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


REPLACE_FILE="gigabot_bedsize.cfg.tmpl"
NEW_FILE="gigabot_bedsize.cfg"
x_str="{x_max_position}"
y_str="{y_max_position}"
z_str="{z_max_position}"

case $1 in
  1)
    x_size="590"; y_size="610"; z_size="609";;
  2)
    x_size="590"; y_size="760"; z_size="900";;
  3)
    x_size="910"; y_size="910"; z_size="910";;
  4)
    echo Exabot current unavailable.; exit 1;;
  *)
    usage; exit 1;;
esac
echo Setting bed size to X:$x_size Y:$y_size Z:$z_size
echo

cat "$REPLACE_FILE" | sed "s/$x_str/$x_size/g" \
      | sed "s/$y_str/$y_size/g" \
      | sed "s/$z_str/$z_size/g" \
      > "$NEW_FILE"