# klipper_config
Klipper Configuration files for Gigabot 3D-Printers

# Gigabot Touchscreen
The Gigabot Touchscreen is built ontop of FullPageOS
This CustomPiOS is a Raspbian image that displays a chromium webpage in full screen mode. 

This repository is used to install additional OS dependencies and repositories to install the Klipper software stack ontop of FullPageOS.


## Easy Install From Release Image

Download the latest release package in releases and follow the instructions in the attached pdf.

## Manual Installation

1. Flash a SD card with FullPageOS using the [Raspberry Pi Imager](https://www.raspberrypi.com/software/) (Other specific purpose OS)
2. Input the flashed image into a raspberry pi, and ssh into the pi
3. Run ```git clone --branch main https://github.com/Mitchell-Mashburn/klipper_config```
4. Run ```sudo ./src/system_config/install.sh```. Wait for the installation to finish
5. Run ```sudo apt update```
6. Run ```sudo apt upgrade```

## Flashing Firmware

1. Navigate to the kiauh folder ```cd kiauh```
2. run ```./kiauh.sh```
3. option 4 - advanced
4. build + flash
5. due/duet2, Sam3x8e - q to exit, save changes
6. regular flashing method
7. USB

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

### Building an Image 
Below is the guide on creating a customized image of the OS to flash as bootable media. 

### 1. Shrinking partion on Raspberry Pi

-Put the SD you want to copy into a card reader and connect to a usb port on the pi.
-Use a standard raspbian OS on a different SD and boot into it.
-Install gparted on the raspberry pi 
```sudo apt-get install gparted -y```
-Launch gparted from the raspbian OS GUI, in system tools.
-Select the external SD from the pull down menu in the upper right corner.
-Unmount the rootfs partition if it is mounted (a key icon next to it) by right clicking it and selecting unmount. If it is grayed out, then it is not mounted.
-Right click rootfs and select resize/move.
-Select the new size for the partition. Resize to atleast the minimum or slightly larger.
-Click the green check mark at the top and click apply to proceed.
-Shutdown the pi.
-Now insert the SD you want to copy in to boot from. 

### 2. Creating the Disk Image

-Have a formatted USB or similiar media to copy the image onto and insert into the pi.
-Check the mount point of your USB by running 
```lsblk```
-You should see something like sda1 with a mountpoint on /media/pi/usb.
-If you see that there is no mountpoint try rebooting with the USB connected and check again.
-If there is still no mountpoint, then mount it manually by running 
```sudo mkdir /dev/myusb``` to create a directory then ```sudo mount /dev/sda1 /dev/myusb``` to mount it.
-Using dd, copy all the data to an img file similiar to this: 
```sudo dd if=/dev/mmcblk0 of=[mount point]/copy.img bs=1M count=6500 status=progress```
-bs=1M means using megabytes and count=6500 * 1M = 6.5 GB of data it will copy. It's always good to copy more data that you use by a few hundred megabytes.

### 3. Compressing the image 

-Install pishrink.sh and copy it to the /usr/local/bin by running:
```wget https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh```
```sudo chmod +x pishrink.sh```
```sudo mv pishrink.sh /usr/local/bin```
-Navigate to the USB drives root directory
```cd /dev/myusb```
-Use pishrink with the -z parameter to compress your image
```sudo pishrink.sh -z copy.img```

