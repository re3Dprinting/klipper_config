#!/bin/bash

hostnamectl set-hostname "$1"
echo "Hostname has been changed to: $1  - Interface will now connect with: $1.local - System needs to reboot for changes to take effect. "
