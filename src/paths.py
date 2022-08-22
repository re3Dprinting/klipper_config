from pathlib import Path

HOME_PATH = Path(__file__).parent.resolve().parent.parent
KLIPPER_CONFIG_PATH = HOME_PATH / "klipper_config"

SRC_PATH = KLIPPER_CONFIG_PATH / "src"
FGF_PATH = SRC_PATH / "fgf"
FFF_PATH = SRC_PATH / "fff"
COMMON_PATH = SRC_PATH / "common"
PINMAP_PATH = COMMON_PATH / "board_pinmap"

OUTPUT_PATH = KLIPPER_CONFIG_PATH / "build"
THEME_PATH = KLIPPER_CONFIG_PATH / ".theme"
