#!/bin/bash
file=/home/pi
# Get the current timestamp
TIMESTAMP=$(date)

# Use ifconfig for the eth0 interface and pipe it into grep to find the line with the MAC address
MACADDR_ETH0=$(ifconfig eth0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')

# Use ifconfig for the wlan0 interface and pipe it into grep to find the line with the MAC address
MACADDR_WLAN0=$(ifconfig wlan0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')

# Use ifconfig for the wlan0 interface and pipe it into grep to find the line with the inet (IPv4) address
INET_WLAN0=$(ifconfig wlan0 | grep 'inet ' | awk '{print $2}')

# Use hostname to get the current hostname
HOSTNAME=$(hostname)

# Output the MAC addresses, IP address, and hostname
echo "Timestamp: $TIMESTAMP"
echo "The MAC address for eth0 is: $MACADDR_ETH0"
echo "The MAC address for wlan0 is: $MACADDR_WLAN0"
echo "The inet address for wlan0 is: $INET_WLAN0"
echo "The current hostname is: $HOSTNAME"

# Append the output to a text file
echo "Timestamp: $TIMESTAMP" >> $file/shell_log.txt
echo "The MAC address for eth0 is: $MACADDR_ETH0" >> $file/shell_log.txt
echo "The MAC address for wlan0 is: $MACADDR_WLAN0" >> $file/shell_log.txt
echo "The inet address for wlan0 is: $INET_WLAN0" >> $file/shell_log.txt
echo "The current hostname is: $HOSTNAME" >> $file/shell_log.txt
echo "" >> $file/shell_log.txt