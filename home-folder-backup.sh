#! /bin/env/bash
##############################
##GINA
##qwertyomen
##Original 4/19/2022
##Updated 4/19/2022
##############################
#########Description##########
#Takes a user's home directory
#and rsyncs it to a folder.

##Variables##
#Identify usersnames for home folder backup
user1='user 1'
user2='user 2'
#Identify backup location
backloc='/backups/'
#Current time/date for the differential backup time stamp
date='date +%F-%R'

#Create backup folder if it doesn't exist
[ ! -d $backloc ] && mkdir $backloc
##Tasks##
#Quick reminder: rsync -options /source /destination
#Orginal Copy [folder existential check] && create new reference folder
[ ! -d $backloc$user1 ] && rsync -aruv --checksum --log-file=$backloc'rsync.log' /home/$user1 $backloc
[ ! -d $backloc$user2 ] && rsync -aruv --checksum --log-file=$backloc'rsync.log' /home/$user2 $backloc

#Differential Backup [reference folder check] && makes a differential backup excluding reference files
[ -d $backloc$user1 ] && rsync -avh --checksum --log-file=$backloc'rsync_log' --compare-dest=$backloc$user1 /home/$user1/ $backloc$user1'-'$($date)
[ -d $backloc$user2 ] && rsync -avh --checksum --log-file=$backloc'rsync_log' --compare-dest=$backloc$user2 /home/$user2/ $backloc$user2'-'$($date)