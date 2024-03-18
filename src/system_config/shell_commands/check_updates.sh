#!/bash/bin

cd /home/pi/klipper_config/
git fetch
sleep 3
git status | head -n 2
echo "Current Version: "
git describe --tags