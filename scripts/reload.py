#!/usr/bin/python3
import sys
import requests
import json
import os
import configparser
from git import Repo
from pathlib import Path

url = "http://localhost"
home_path = Path(__file__).parent.resolve().parent.parent
klipper_path = home_path / "klipper"
moonraker_path = home_path / "moonraker"

klipper_config_path = home_path / "klipper_config"
klipper_config_scripts = klipper_config_path / "scripts"
master_config_path = klipper_config_path / ".master.cfg"

master_config = configparser.ConfigParser(inline_comment_prefixes="#")
master_config.read(str(master_config_path))
master_config = master_config["re3D"]

MASTER_BRANCH_VALID = {"stable", "develop"}
KLIPPER_BRANCH_MAP = {"stable": "master", "develop": "develop"}
MOONRAKER_BRANCH_MAP = {"stable": "master", "develop": "develop"}
KLIPPER_CONFIG_BRANCH_MAP = {"stable": "", "develop": "-develop"}

def wait_on_moonraker():
    print("Waiting on moonraker...")
    from requests.adapters import HTTPAdapter, Retry
    s = requests.Session()
    retries = Retry(total=5, backoff_factor=1, status_forcelist=[ 502, 503, 504 ])
    s.mount('http://', HTTPAdapter(max_retries=retries))
    s.get(url + "/server/database/list")

#Reloading serial script, Import script directly to run it.
def trigger_setup_printer():
    if (klipper_config_scripts / "setup_printer.py").is_file():
        sys.path.append(str(klipper_config_scripts))
        import setup_printer
        setup_printer.main()
    else:
        print("Could not locate setup_printer.py in {}!".format(klipper_config_path))

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

def moonraker_klipper_branch_check():
    branch = master_config.get("branch", fallback="stable")
    print("Master Config Branch set to " + branch)
    if branch not in MASTER_BRANCH_VALID: 
        print("\t" +branch+ " is invalid, defaulting to stable")
        branch = "stable"

    target_klipper_branch = KLIPPER_BRANCH_MAP.get(branch)
    target_moonraker_branch = MOONRAKER_BRANCH_MAP.get(branch)
    print("Configuring klipper repo to " + target_klipper_branch)
    print("Configuring moonraker repo to " + target_moonraker_branch)

    print("Initializing repo objects...")
    klipper_git_repo = Repo(klipper_path)
    moonraker_git_repo = Repo(moonraker_path)

    print("Fetching origin and pruning...")
    klipper_git_repo.remotes.origin.fetch(prune=True)
    moonraker_git_repo.remotes.origin.fetch(prune=True)

    print("Checking if repos are dirty...")
    klipper_repo_dirty = klipper_git_repo.is_dirty()
    moonraker_repo_dirty = moonraker_git_repo.is_dirty()
    print("\tKlipper -- {}".format(klipper_repo_dirty))
    print("\tMoonraker -- {}".format(moonraker_repo_dirty))
    if klipper_repo_dirty or moonraker_repo_dirty:
        return False

    # Check if branch exists
    #TODO Actually check if the name matches by doing a .split("/")[-1]. 
    for b in klipper_git_repo.remote().refs: 
        if target_klipper_branch in b.name:
            print("Klipper Target Branch exists...")
    for b in moonraker_git_repo.remote().refs:
        if target_moonraker_branch in b.name:
            print("Moonraker Target Branch exists...")
    
    #Checkout Branch
    klipper_git_repo.git.checkout(target_klipper_branch)
    moonraker_git_repo.git.checkout(target_moonraker_branch)

def klipper_config_branch_check():
    branch = master_config.get("branch", fallback="stable")
    print("Master Config Branch set to " + branch)
    if branch not in MASTER_BRANCH_VALID: 
        print("\t" +branch+ " is invalid, defaulting to stable")
        branch = "stable"
    extruder = master_config.get("extruder")
    if extruder not in MASTER_EXTRUDER_VALID:
        print("\t"+extruder+ " is not valid. Skipping klipper_config branch check")
    
    target_klipper_config_branch = "{}-{}".format(extruder, branch)
    if branch is "stable": target_klipper_config_branch = extruder

    print("Configuring klipper_config repo to " + target_klipper_config_branch)

    print("Initializing repo objects...")
    klipper_config_git_repo = Repo(klipper_config_path)

    print("Fetching origin and pruning...")
    klipper_config_git_repo.remotes.origin.fetch(prune=True)

    print("Checking if repos are dirty...")
    klipper_config_repo_dirty = klipper_config_git_repo.is_dirty()
    print("\tKlipper_config -- {}".format(klipper_config_repo_dirty))
    if klipper_config_repo_dirty:
        return False
 
    for b in klipper_config_git_repo.remote().refs: 
        if target_klipper_config_branch in b.name:
            print("Klipper Target Branch exists...")
    
    #Checkout Branch
    klipper_config_git_repo.git.checkout(target_klipper_config_branch)

#Manage Moonraker, Klipper, virtual_keyboard version, based on klipper_config hashes
#Fetch update manager status endpoint /machine/update/status?refresh=true

#pull in klipper_config master.cfg, see if branch is on stable or develop, 
# check out Moonraker, Klipper, klipper_config develop branches if set to develop

def reboot_services():
    os.system("service moonraker restart")
    os.system("service klipper restart")
    os.system("service lightdm restart")

def main():
    wait_on_moonraker()

    if check_network_availability():
        moonraker_klipper_branch_check()
        # klipper_config_branch_check()

    trigger_setup_printer()
    reload_ui()
    reboot_services()

if __name__ == "__main__":
    main()

