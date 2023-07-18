#!/bin/bash

echo "pi:$1" | chpasswd
echo "Password has been changed to: $1"
