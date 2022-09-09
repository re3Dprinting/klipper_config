#!/bin/bash

PWD="$(cd "$(dirname "$0")" && pwd)"

install -p -m 644 $PWD/88x2bu.ko  /lib/modules/5.10.17-v7l+/kernel/drivers/net/wireless/
/sbin/depmod -a 5.10.17-v7l+
