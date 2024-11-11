#!/bin/bash
#Author: qwertyomen - 2024

status_check() {
    device_name="$1"

    if ($test_1 != 'PASSED' 
test_1=($(sudo smartctl -H "$device_name" | grep -i 'test result' | awk -F ': ' '{print $2}'))
test_2=($(sudo smartctl -H "$device_name" | grep -i 'Health Status' | awk -F ': ' '{print $2}'))