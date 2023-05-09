#!/bin/bash

usage() {
  cat << EOF # remove the space between << and EOF, this is due to web plugin issue
Usage: $(basename "${BASH_SOURCE[0]}")
EOF
  exit
}

if [ "$EUID" -ne 0 ]
  then echo "Please run as root, try: sudo ./integrate.sh"
  exit
fi

PWD="$(CD "$(dirname "$0")" && pwd)"
HOME=~PWD/../../..

cd $HOME
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
apt-get update
apt-get install tailscale
