#!/bin/bash 

out=/tmp/autoconnect_wifi.out
env > $out

function grep_string {
    path=$1
    string=$2
    result=$(cat $path | grep "^\s*$string" )
    if [[ -z $result ]]; then
        echo "Could not find line with $string in $path"
        if [ "$3" == "exit" ]; then 
            exit 1 
        fi
        return 
    fi
    echo "Found $string in $path"
}

function check_null {
    if [[ -z $2 ]]; then
        echo "Nothing set for $1"
    fi
}

function check_connection {
    ping -c 5 8.8.8.8 >> /dev/null
    if [[ $? -eq  0 ]]; then
        echo "Connected to Internet!"
        ./scan_wifi.sh
        exit 0
    fi
}

WPA_CONF_PATH="/etc/wpa_supplicant/wpa_supplicant.conf"
CONFIG_PATH="/home/pi/klipper_config/wifi_setup.conf"

while true;
do
    check_connection

    echo "Not connected to Internet!"
    ./scan_wifi.sh
    echo "Checking if wpa_supplicant.conf can be updated with klipper_conf/wifi_setup.conf"
    # Grab the wifi ssid and password from wpa_supplicant
    grep_string $WPA_CONF_PATH "ssid=" "exit"
    grep_string $WPA_CONF_PATH "psk=" "exit"

    SET_WPA_SSID=$( cat $WPA_CONF_PATH | grep "^\s*ssid" | grep -o '"[^"]\+"' | sed "s/\"//g")
    SET_WPA_PASS=$( cat $WPA_CONF_PATH | grep "^\s*psk" | grep -o '"[^"]\+"' | sed "s/\"//g")
    echo "Grabbed current ssid: $SET_WPA_SSID psk: $SET_WPA_PASS"

    CONFIG_SSID_VALID=$(grep_string $CONFIG_PATH "ssid=")
    CONFIG_PASS_VALID=$(grep_string $CONFIG_PATH "psk=")

    CONFIG_WPA_SSID=$( cat $CONFIG_PATH | grep "^\s*ssid" | grep -o '[^=]\+$' | xargs )
    CONFIG_WPA_PASS=$( cat $CONFIG_PATH | grep "^\s*psk" | grep -o '[^=]\+$' | xargs )
    echo "Grabbed config ssid: $CONFIG_WPA_SSID psk: $CONFIG_WPA_PASS"

    if [[ -z "$CONFIG_SSID_VALID" || -z "$CONFIG_WPA_SSID" ]]; then
        echo "ssid in $config_path is invalid"
    elif [[ -z "$CONFIG_PASS_VALID" || -z "$CONFIG_WPA_PASS" ]]; then
        echo "psk in $config_path is invalid"
    elif [[ "$SET_WPA_SSID" == "$CONFIG_WPA_SSID" && 
            "$SET_WPA_PASS" == "$CONFIG_WPA_PASS" ]]; then
        echo "Set WPA is same as config. Skipping... "
    else
        echo "Set WPA in klipper_config detected different. Overwriting..."
        SSID_LINE=$( cat $WPA_CONF_PATH | grep "^\s*ssid" )
        PASS_LINE=$( cat $WPA_CONF_PATH | grep "^\s*psk" )
        REPLACE_SSID_LINE=$( cat $WPA_CONF_PATH | grep "^\s*ssid" | sed "s/$SET_WPA_SSID/$CONFIG_WPA_SSID/g")
        REPLACE_PASS_LINE=$( cat $WPA_CONF_PATH | grep "^\s*psk" | sed "s/$SET_WPA_PASS/$CONFIG_WPA_PASS/g" )
        
        sed -i "s/$SSID_LINE/$REPLACE_SSID_LINE/g" $WPA_CONF_PATH
        sed -i "s/$PASS_LINE/$REPLACE_PASS_LINE/g" $WPA_CONF_PATH

        systemctl daemon-reload
        systemctl restart dhcpcd
    fi

    echo
    
    sleep 3s
done
