#!/bin/bash
#author: qwertyomen - 2024

find /dev -maxdepth 1 -group disk -name 'md*' -print0 | while read -d $'\0' file
do
    raid_check=$(mdadm -D $file | grep "State :" | awk -F ': ' '{ print $2 }')
    if [ "$raid_check" == "clean " ]; then
    echo "good "$file$raid_check
    else
    echo "Failed  "$file$raid_check
    fi

done