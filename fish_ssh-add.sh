#!/bin/bash
#qwertyomen
#12/6/2024
#Name: fish_ssh-add.sh
#Purpose: Set SSH Environment Variables to make ssh-add easier in fish

set SSH_AUTH_SOCK $(ssh-agent -c | grep SOCK | awk '{print $3}' | sed 's/;//')
set SSH_AGENT_PID $(ssh-agent -c | grep echo | awk '{print $4}' | sed 's/;//g')
ssh-add