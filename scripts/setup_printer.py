#!/bin/python3
import shutil
from pathlib import Path

klipper_scripts = Path(__file__).parent.resolve()
KLIPPER_PATH = klipper_scripts.parent
COMMON_PATH = KLIPPER_PATH / "common"
PINMAP_PATH = KLIPPER_PATH / "board_pinmap"

FGF_PATH = KLIPPER_PATH / "fgf"
FFF_PATH = KLIPPER_PATH / "fff"
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


def add_platform_type(platform, platform_path):
    valid_platform = ["regular", "xlt", "terabot"]
    if platform not in valid_platform:
        print("Invalid platform type in master.cfg, defaulting to regular")
        platform = "regular"

    platform_file = (platform + ".cfg")
    generate_platform = OUTPUT_PATH / platform_file
    template_platform = platform_path / platform_file
    add_template_file(template_platform, generate_platform, True) 


def add_board_type(board, board_path):
    valid_board = ["azteeg", "archimajor"]
    if board not in valid_board:
        print("Invalid board type in master.cfg, defaulting to archim")
        board = "archim"

    board_pinmap_file = board + "_pinmap.cfg"
    generate_board_pinmap = OUTPUT_PATH / board_pinmap_file
    template_board_pinmap = klipper_path / "board_pinmap" / board_pinmap_file
    add_template_file(template_board_pinmap, generate_board_pinmap, True)

    board_specific_file = board + "_specific.cfg"
    generate_board_specific= OUTPUT_PATH / board_specific_file
    template_board_specific = board_path / (board + "_specific.cfg")
    add_template_file(template_board_specific, generate_board_specific, True)

def is_valid_path(path):
    if not path.exists():
        print("{path} is missing!")
        return False
    return True

def setup_printer(printer_config, deposition_type):
    deposition_type_path = FGF_PATH if deposition_type is "fgf" else FFF_PATH

    platform_path = deposition_type_path / "platform_specific"
    board_path = deposition_type_path / "board_specific"
    if not is_valid_path(platform_path) or not is_valid_path(board_path):
        return

    #Platform Setup
    add_platform_type(printer_config.get("platform_type", ""), platform_path)
    #Board Setup
    add_board_type(printer_config.get("board_type", ""), board_path)

    #Common Files Setup
    add_template_file(COMMON_PATH / "save_variables.cfg", KLIPPER_PATH / "_save_variables.cfg")
    add_template_file(COMMON_PATH / "standalone.cfg", KLIPPER_PATH / "_standalone.cfg")
    add_template_file(COMMON_PATH / "wifi_setup.conf.tmpl", KLIPPER_PATH / "wifi_setup.conf")
    add_template_file(COMMON_PATH / "moonraker.conf.tmpl", KLIPPER_PATH / "moonraker.conf", True)

