#!/bin/bash

cd ~
mv ~/printer_data/config/standalone.cfg ~/standaloneTMP.cfg
mv ~/printer_data/config/crowsnest.cfg ~/standaloneTMP.cfg
mv ~/printer_data/config/timelapse.cfg ~/timelapseTMP.cfg
rm -rf ~/printer_data/config
cp -a ~/klipper_config/. ~/printer_data/config/
mv ~/standaloneTMP.cfg ~/printer_data/config/standalone.cfg
mv ~/crowsnestTMP.cfg ~/printer_data/config/crowsnest.cfg
mv ~/timelapseTMP.cfg ~/printer_data/config/timelapse.cfg
