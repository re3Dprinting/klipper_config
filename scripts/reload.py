#!/usr/bin/python3
import sys
import requests
import json
import os
import configparser
from pathlib import Path

import setup_printer
from setup_printer import add_template_file, COMMON_PATH
from branch_check import moonraker_klipper_branch_check

url = "http://localhost"
home_path = Path(__file__).parent.resolve().parent.parent

klipper_config_path = home_path / "klipper_config"
fgf_config_path = klipper_config_path / "fgf"
fff_config_path = klipper_config_path / "fff"

def read_master_config():
    master_config_path = klipper_config_path / ".master.cfg"
    if not master_config_path.exists():
        print(".master.cfg is missing! autogenerating to default")
        add_template_file(COMMON_PATH / "master.cfg", master_config_path)

    master_config = configparser.ConfigParser(inline_comment_prefixes="#")
    master_config.read(str(master_config_path))
    return master_config["re3D"]
    # for p in printer_config: print(p)

def wait_on_moonraker():
    print("Waiting on moonraker...")
    from requests.adapters import HTTPAdapter, Retry
    s = requests.Session()
    retries = Retry(total=5, backoff_factor=1, status_forcelist=[ 502, 503, 504 ])
    s.mount('http://', HTTPAdapter(max_retries=retries))
    s.get(url + "/server/database/list")

#Reloading UI configuration
def reload_ui():
    default_json_file = klipper_config_path / ".theme/default.json"
    with open(default_json_file) as f:
        defaults = json.load(f)
    namespaces = [name for name in defaults]

    for name in namespaces:
        default_value = defaults[name]
        print("{} Namespace Default: {}".format(name, default_value))
        print("--- DELETING {} NAMESPACE ---".format(name))
        delete_url = url+"/server/database/item?namespace=mainsail&key="+name
        delete_response = requests.delete(delete_url)
        print(delete_response.text)

        print("--- POSTING NEW DEFAULT INTO {} NAMESPACE ---".format(name))
        post_url = url+"/server/database/item"
        body = {"namespace": "mainsail", "key": name, "value": defaults[name]}
        post_response = requests.post(post_url, json=body)
        print(post_response.text)
    
def check_network_availability():
    try:
        request = requests.get("http://www.google.com", timeout=5)
        print("Network Available")
        return True
    except:
        print("Network Unavailable, skipping dependency checking")
        return False

def reboot_services():
    os.system("service moonraker restart")
    os.system("service klipper restart")
    os.system("service lightdm restart")

def main():
    master_config = read_master_config()
    #Block until moonraker system service comes up. 
    wait_on_moonraker()
    if check_network_availability():
        moonraker_klipper_branch_check(master_config=master_config)

    setup_printer.main()
    reload_ui()
    reboot_services()

if __name__ == "__main__":
    main()

