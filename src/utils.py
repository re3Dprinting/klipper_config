import requests
import shutil
from pathlib import Path

def validate_and_return_config_param(field, config, valid_selections, default):
    selection = config.get(field, "")
    if selection not in valid_selections:
        print("WARN: {} is invalid for section {} in config, defaulting to {}".format(selection, field, default))
        return default
    return selection
    
def check_network_availability():
    try:
        request = requests.get("http://www.google.com", timeout=5)
        print("INFO: Network Available")
        return True
    except:
        print("WARN: Network Unavailable, skipping dependency checking")
        return False

def add_template_file(template_file, add_file, replace=False):
    if not is_valid_path(template_file):
        return
    elif not replace and Path(add_file).exists():
        print("INFO: {} exists! skipping...".format(add_file))
        return
    shutil.copyfile(template_file, add_file)
    print("INFO: Adding/Overwriting {}".format(add_file))

def is_valid_path(path):
    if not path.exists():
        print("WARN: {} does not exist!".format(path))
        return False
    return True
