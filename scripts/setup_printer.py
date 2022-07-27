#!/bin/python3
import shutil
import subprocess
from pathlib import Path

klipper_scripts = Path(__file__).parent.resolve()
KLIPPER_PATH = klipper_scripts.parent
COMMON_PATH = KLIPPER_PATH / "templates"
PINMAP_PATH = KLIPPER_PATH / "board_pinmap"

FGF_PATH = KLIPPER_PATH / "fgf"
FFF_PATH = KLIPPER_PATH / "fff"
platform_path = KLIPPER_PATH / "platform_specific"
board_path = KLIPPER_PATH / "board_specific"

OUTPUT_PATH = KLIPPER_PATH / "build"

#attempt to generate master.cfg from master.cfg.tmpl
#read in master.cfg

#set bedsize, get_bedsize.sh
#set serial, get_serial.sh (if currently plugged in usb is different override)
#set board, overwrite board_pinmap, board_specific

#add if doesnt exist - save_variables.cfg
#add if doesnt exist - standalone.cfg
#add if doesnt exist - wifi_setup.cfg

#overwrite - moonraker.cfg check git hash for correct moonraker.cfg

def add_template_file(template_file, add_file, replace=False):
    if not replace and Path(add_file).exists():
        print("{} exists! skipping...".format(add_file))
        return
    shutil.copyfile(template_file, add_file)
    print("Adding/Overwriting {}".format(add_file))


def add_platform_type(platform):
    valid_platform = ["regular", "xlt", "terabot"]
    if platform not in valid_platform:
        print("Invalid platform type in master.cfg, defaulting to regular")
        platform = "regular"

    generate_platform = KLIPPER_PATH / "_platform_type.cfg"
    template_platform = platform_path / (platform + ".cfg")
    add_template_file(template_platform, generate_platform, True) 

def add_board_type(board):
    valid_board = ["azteeg", "archimajor"]
    if board not in valid_board:
        print("Invalid board type in master.cfg, defaulting to archim")
        board = "archim"

    board_pinmap_file = board + "_pinmap.cfg"
    board_specific_file = board + "_specific.cfg"
    generate_board_pinmap = OUTPUT_PATH / board_pinmap_file
    generate_board_specific= OUTPUT_PATH / board_specific_file
    template_board_pinmap = board_path / (board + "_pinmap.cfg")
    template_board_specific = board_path / (board + "_specific.cfg")
    add_template_file(template_board_pinmap, generate_board_pinmap, True)
    add_template_file(template_board_specific, generate_board_specific, True)

def main(printer_config):
    #Platform Setup
    add_platform_type(printer_config.get("platform_type", ""))
    #Board Setup
    add_board_type(printer_config.get("board_type", ""))

    #Template File Setup
    add_template_file(COMMON_PATH / "save_variables.cfg", KLIPPER_PATH / "_save_variables.cfg")
    add_template_file(COMMON_PATH / "standalone.cfg", KLIPPER_PATH / "_standalone.cfg")
    add_template_file(COMMON_PATH / "wifi_setup.conf.tmpl", KLIPPER_PATH / "wifi_setup.conf")
    add_template_file(COMMON_PATH / "moonraker.conf.tmpl", KLIPPER_PATH / "moonraker.conf", True)

    #Serial Setup
    serial_out = subprocess.run([str(klipper_scripts / "get_serial.sh")], capture_output=True)
    print(serial_out.stdout.decode("utf-8"))
