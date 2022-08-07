#!/bin/bash

DIR="$(cd "$(dirname "$0")" && pwd)"
$DIR/xrandr.sh 1024 600 75
#$DIR/rotate.sh inverted
