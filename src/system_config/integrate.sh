#!/bin/bash

cd ~
mv ~/printer_data/config/standalone.cfg ~/standaloneBKP.cfg
rm -rf ~/printer_data/config
cp -a ~/klipper_config/. ~/printer_data/config/
mv ~/standaloneBKP.cfg ~/printer_data/config/standalone.cfg