#!/bin/bash
#author: qwertyomen - 2024

echo "Hostname or IP?"
read host
echo "Port?"
read port
#echo "Protocol: TCP or UDP?"
#echo "timeout in seconds"
#read $timeout

nc -w 5 -zv $host $port &>/dev/null && echo "TCP/"$port" Open on "$host || echo "TCP/"$port" Closed on "$host
