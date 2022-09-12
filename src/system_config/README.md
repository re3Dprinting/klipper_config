# Gigabot Touchscreen
The Gigabot Touchscreen is built ontop of [FullPageOS](https://github.com/guysoft/FullPageOS)
This CustomPiOS is a Raspbian image that displays a chromium webpage in full screen mode. 

This repository is used to install additional OS dependencies and repositories to install the Klipper software stack ontop of FullPageOS.

## Installation

1. Flash a SD card with FullPageOS using a image flasher such as the [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
2. Input the flashed image into a raspberry pi, and ssh into the pi
3. Run ```git clone https://github.com/re3Dprinting/gigabot_touchscreen_config```
4. Run ```sudo ./gigabot_touchscreen_config/install.sh```. Wait for the installation to finish
5. Once the installation finishes, you should be able to plug in the re3D Touchscreen and pull up the Mainsail interface

## More Details
As stated above, there are many Fullpageos_modifications specific to getting the raspberry pi to display its interface on the HMTech Display.

apt-get Dependencies ontop of FullpageOS:

```xinput ripgrep nmap```

Other system level configurations are as

### Disable Scrollbar
Add ``` --enable-features=OverlayScrollbar ``` to starting chromium script, ```~/scripts/start_chromium_browser```

### Disable Cursor
Append ```xserver-command=X -nocursor``` to ```/usr/share/lightdm/lightdm.conf.d/01_debian.conf```

### Add Keyboard Extension to Chromium
Copy ```.config ``` to home directory of pi

### Enable full kms graphics driver
Append ```dtoverlay=vc4-kms-v3d``` to ```/boot/config.txt```

### Adjust screen resolution permenantly
Upload ```xrandr/``` script file, and add ```lightdm.conf``` to ```/etc/lightdm/lightdm.conf```
Move ```lightdm.conf``` to ```/etc/lightdm/```

### Allow for screen rotations
Install xinput with ```sudo apt install xinput```
enable full kms driver, and run ```~/scripts/rotate.sh left```

### Disable boot text 
Upload ```cmdline.txt``` to ```/boot/```

### Troubleshooting
Get lightdm service status ```journalctl -u lightdm.service```

### Recording with autoexpect
```autoexpect -p ./kiauh/kiauh.sh```

### Installation
Clone the repo onto a base image of FullPageOs
```git clone https://github.com/plloppii/gigabot_touchscreen_config ```
Run the install script
```./gigabot_touchscreen_config/install.sh```

### Kernal Module Compilation for AC1200 USB Wifi Antenna
```
sudo apt update
sudo apt upgrade

sudo apt install -y bc git flex bison libssl-dev libncurses5-dev
sudo wget https://raw.githubusercontent.com/RPi-Distro/rpi-source/master/rpi-source -O /usr/local/bin/rpi-source && sudo chmod +x /usr/local/bin/rpi-source && /usr/local/bin/rpi-source -q --tag-update
rpi-source

sudo git clone https://github.com/cilynx/rtl88x2bu
cd rtl8822bu
sudo nano Makefile

# Update lines 100 and 101 to this and save the file:
# CONFIG_PLATFORM_I386_PC = n
# CONFIG_PLATFORM_ARM_RPI = y -->

sudo make
sudo make install
sudo reboot
```

### Shrinking Pi Image on MacOs

```
# ON PI - Zero out the empty space in the filesystem to make the image more compressible.
dd if=/dev/zero of=/tmp/zero.out bs=1024k
rm /tmp/zero.out

# ON PI - Halt the operating system and transfer the microSD card to a Linux or Mac computer.
sudo halt -p

# Dump and compress the operating system image.
sudo dd if=/dev/sdd of=ts-raspbian-base-yyyy.mm.dd.img
bzip2 -v -9 ts-raspbian-base-yyyy.mm.dd.img

# Using PiShrink to Compress Image
docker run --privileged=true --rm \
    --volume $(pwd):/workdir \
    mgomesborges/pishrink \
    pishrink -Zv IMAGE_NAME.img NEW-IMAGE_NAME.img
```