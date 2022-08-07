#!/bin/bash 
nmap -sn 10.1.10.1/24 | grep -B2 Raspberry | grep 10.1.10