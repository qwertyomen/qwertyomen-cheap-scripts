#!/bin/bash
#Author: Michael Peterson - 2024
#Sanitized

read -p 'Enter Hostname: ' hostname
read -p 'Enter Power Command: ' pc
read -sp 'Password: ' pw
echo
ipmitool -H $hostname -U admin -P $pw chassis power $pc