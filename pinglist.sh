#!/bin/bash
# Program name: pingall.sh
#author: qwertyomen - 2024
date
cat ./pinglist.csv |  while read output
do
    ping -c1 "$output" > /dev/null
    if [ $? -eq 0 ]; then
    echo "node $output is up"
    else
    echo "node $output is down"
    fi
done
