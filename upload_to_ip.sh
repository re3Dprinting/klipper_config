#!/bin/bash

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [ip]

Choose which Gigabot uploading config files to
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

REPLACE_FILE="gigabot_steppers_base.cfg"
NEW_FILE="gigabot_steppers.cfg"
x_str="{x_max_position}"
y_str="{y_max_position}"
z_str="{z_max_position}"

read -p "Enter Gigabot Size: (1)Regular (2)XLT (3)Terabot (4)Exabot: " model; echo
case $model in
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

echo Uploading to IP 192.168.1.$1
scp -r {./*.cfg,./*.conf,./get_serial.sh} pi@192.168.1.$1:~/klipper_config/

rm $NEW_FILE
