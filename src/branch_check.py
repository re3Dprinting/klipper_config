from git import Repo
from pathlib import Path
from paths import *
import configparser

class VersionManager:
    def __init__(self, target_branch):
        print("INFO: Initializing repo objects...")
        self.klipper_git_repo = Repo(KLIPPER_PATH)
        self.moonraker_git_repo = Repo(MOONRAKER_PATH)
        self.virtual_keyboard_git_repo = Repo(VIRTUAL_KEYBOARD_PATH)

        print("INFO: Fetching origin and pruning...")
        self.klipper_git_repo.remotes.origin.fetch(prune=True)
        self.moonraker_git_repo.remotes.origin.fetch(prune=True)
        self.virtual_keyboard_git_repo.remotes.origin.fetch(prune=True)

    def validate_repository_hashes(self):
        versions_config = configparser.ConfigParser(inline_comment_prefixes="#")
        versions_config.read(str(VERSIONS_FILE))
        versions = versions_config["versions"]
        target_klipper_hash = versions["klipper"]
        target_moonraker_hash = versions["moonraker"]
        target_virtual_keyboard_hash = versions["virtual_keyboard"]

        klipper_hash = self.klipper_git_repo.head.object.hexsha
        moonraker_hash = self.moonraker_git_repo.head.object.hexsha
        virtual_keyboard_hash = self.virtual_keyboard_git_repo.head.object.hexsha

        if klipper_hash != target_klipper_hash:
            print(f'WARN: klipper Repo hash does not match target hash! {klipper_hash} != {target_klipper_hash}')
        if moonraker_hash != target_moonraker_hash:
            print(f'WARN: moonraker Repo hash does not match target hash! {moonraker_hash} != {target_moonraker_hash}')
        if virtual_keyboard_hash != target_virtual_keyboard_hash:
            print(f'WARN: virtual_keyboard Repo hash does not match target hash! {virtual_keyboard_hash} != {target_virtual_keyboard_hash}')


    def set_custom_branch(self, master_config):
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
        klipper_config_git_repo = Repo(KLIPPER_CONFIG_PATH)

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

