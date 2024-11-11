#!/bin/bash
#weekly system checks - incomplete, knife does poorly in a bash script *SURPRISE*
#author: qwertyomen - 2024

#Check data-storage systems for RAID errors
knife ssh --no-host-key-verify 'name:data-storage*' 'sudo mdadm -D /dev/md* | grep \'State :\''
knife ssh --no-host-key-verify 'name:nrt-s-*' 'sudo mdadm -D /dev/md* | grep \'State :\''
