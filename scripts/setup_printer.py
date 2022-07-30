#!/bin/python3
import shutil
import os
import subprocess
from pathlib import Path

from utils import add_template_file, is_valid_path

klipper_scripts = Path(__file__).parent.resolve()
KLIPPER_PATH = klipper_scripts.parent
COMMON_PATH = KLIPPER_PATH / "common"
PINMAP_PATH = COMMON_PATH / "board_pinmap"

FGF_PATH = KLIPPER_PATH / "fgf"
FFF_PATH = KLIPPER_PATH / "fff"
board_path = KLIPPER_PATH / "board_specific"

OUTPUT_PATH = KLIPPER_PATH / "build"
THEME_PATH = KLIPPER_PATH / ".theme"

#attempt to generate master.cfg from master.cfg.tmpl
#read in master.cfg

#set bedsize, get_bedsize.sh
#set serial, get_serial.sh (if currently plugged in usb is different override)
#set board, overwrite board_pinmap, board_specific

#add if doesnt exist - save_variables.cfg
#add if doesnt exist - standalone.cfg
#add if doesnt exist - wifi_setup.cfg

#overwrite - moonraker.cfg check git hash for correct moonraker.cfg

def add_platform_specific(platform, board, platform_path):
    platform_file = "{}_{}.cfg".format(board, platform)
    generate_platform = OUTPUT_PATH / platform_file
    template_platform = platform_path / platform_file
    add_template_file(template_platform, generate_platform, True) 

def add_board_pinmap(board):
    board_pinmap_file = board + "_pinmap.cfg"
    generate_board_pinmap = OUTPUT_PATH / board_pinmap_file
    template_board_pinmap = PINMAP_PATH / board_pinmap_file
    add_template_file(template_board_pinmap, generate_board_pinmap, True)


def add_board_specific(board, board_path):
    board_specific_file = board + "_specific.cfg"
    generate_board_specific= OUTPUT_PATH / board_specific_file
    template_board_specific = board_path / board_specific_file
    add_template_file(template_board_specific, generate_board_specific, True)

def add_config(config_path):
    if not is_valid_path(config_path): return 
    for config_file in config_path.iterdir():
        generate_file = OUTPUT_PATH / config_file.name
        add_template_file(config_file, generate_file, True)

def add_theme(theme_path):
    if not is_valid_path(theme_path): return 
    for theme_file in theme_path.iterdir():
        generate_file = THEME_PATH / theme_file.name
        add_template_file(theme_file, generate_file, True)

def setup_printer(deposition_type, board, platform):
    deposition_type_path = FGF_PATH if deposition_type == "fgf" else FFF_PATH

    platform_path = deposition_type_path / "platform_specific"
    board_path = deposition_type_path / "board_specific"
    config_path = deposition_type_path / "config"
    theme_path = deposition_type_path / ".theme"
    if not is_valid_path(platform_path) or not is_valid_path(board_path):
        return
    
    # Wipe and recreate build path
    if is_valid_path(OUTPUT_PATH): 
        shutil.rmtree(OUTPUT_PATH)
    os.mkdir(OUTPUT_PATH)

    # Wipe and recreate .theme path
    if is_valid_path(THEME_PATH): 
        shutil.rmtree(THEME_PATH)
    os.mkdir(THEME_PATH)

    # Platform Setup
    add_platform_specific(platform, board, platform_path)
    # Board Pinmap Setup
    add_board_pinmap(board)
    # Board Specific Setup
    add_board_specific(board, board_path)
    #Rest of the config setup
    add_config(config_path)
    #Setup theme path
    add_theme(theme_path)

    #Common Files Setup
    add_template_file(COMMON_PATH / "save_variables.cfg", KLIPPER_PATH / "_save_variables.cfg")
    add_template_file(COMMON_PATH / "standalone.cfg", KLIPPER_PATH / "_standalone.cfg")
    add_template_file(COMMON_PATH / "wifi_setup.conf.tmpl", KLIPPER_PATH / "wifi_setup.conf")
    add_template_file(COMMON_PATH / "moonraker.conf.tmpl", KLIPPER_PATH / "moonraker.conf", True)

    #Serial Setup
    serial_out = subprocess.run([str(klipper_scripts / "get_serial.sh")], capture_output=True)
    print(serial_out.stdout.decode("utf-8"))
