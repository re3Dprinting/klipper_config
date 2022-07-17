#!/bin/bash
export DISPLAY=:0
DIR="$(cd "$(dirname "$0")" && pwd)"
$DIR/rotate.sh normal
