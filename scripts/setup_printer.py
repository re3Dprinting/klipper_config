#!/bin/python3
import sys, shutil, configparser, subprocess
from pathlib import Path

klipper_scripts = Path(__file__).parent.resolve()
klipper_path = klipper_scripts.parent
template_path = klipper_path / "templates"
platform_path = klipper_path / "platform_type"
board_path = klipper_path / "board_type"

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

    generate_platform = klipper_path / "_platform_type.cfg"
    template_platform = platform_path / (platform + ".cfg")
    add_template_file(template_platform, generate_platform, True) 

def add_board_type(board):
    valid_board = ["azteeg", "archimajor"]
    if board not in valid_board:
        print("Invalid board type in master.cfg, defaulting to archim")
        board = "archim"

    generate_board_pinmap = klipper_path / "_board_pinmap.cfg"
    generate_board_specific= klipper_path / "_board_specific.cfg"
    template_board_pinmap = board_path / (board + "_pinmap.cfg")
    template_board_specific = board_path / (board + "_specific.cfg")
    add_template_file(template_board_pinmap, generate_board_pinmap, True)
    add_template_file(template_board_specific, generate_board_specific, True)

def main():
    #Handle First Time .master.cfg Generation
    master_config_path = klipper_path / ".master.cfg"
    args = sys.argv
    for arg in args:
        if arg == "-g":
            print("First time setup, generating .master.cfg")
            add_template_file(template_path / "master.cfg", master_config_path)

    if not master_config_path.exists():
        print(".master.cfg is missing! autogenerating to default")
        add_template_file(template_path / "master.cfg", master_config_path)

    master_config = configparser.ConfigParser(inline_comment_prefixes="#")
    master_config.read(str(master_config_path))
    printer_config = master_config["re3D"]
    # for p in printer_config: print(p)

    #Platform Setup
    add_platform_type(printer_config.get("platform_type", ""))
    #Board Setup
    add_board_type(printer_config.get("board_type", ""))

    #Template File Setup
    add_template_file(template_path / "save_variables.cfg", klipper_path / "_save_variables.cfg")
    add_template_file(template_path / "standalone.cfg", klipper_path / "_standalone.cfg")
    add_template_file(template_path / "wifi_setup.conf.tmpl", klipper_path / "wifi_setup.conf")
    add_template_file(template_path / "moonraker.conf.tmpl", klipper_path / "moonraker.conf", True)

    #Serial Setup
    serial_out = subprocess.run([str(klipper_scripts / "get_serial.sh")], capture_output=True)
    print(serial_out.stdout.decode("utf-8"))

if __name__ == "__main__":
    main()