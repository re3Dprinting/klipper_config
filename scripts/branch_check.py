from git import Repo
from pathlib import Path

MASTER_BRANCH_VALID = {"stable", "develop"}
KLIPPER_BRANCH_MAP = {"stable": "master", "develop": "develop"}
MOONRAKER_BRANCH_MAP = {"stable": "master", "develop": "develop"}
KLIPPER_CONFIG_BRANCH_MAP = {"stable": "", "develop": "-develop"}

home_path = Path(__file__).parent.resolve().parent.parent
klipper_path = home_path / "klipper"
moonraker_path = home_path / "moonraker"
klipper_config_path = home_path / "klipper_config"

def moonraker_klipper_branch_check(branch):
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

def klipper_config_branch_check(master_config):
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

