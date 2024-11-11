#!/bin/bash
#author: qwertyomen - 2024
#admin email account
ADMIN="alert@url.com"

# set usage alert threshold
THRESHOLD=90

#hostname
HOSTNAME=$(hostname)

#mail client
MAIL=`which mail`

# store all disk info here
EMAIL=""

for line in $(df -iP | egrep '^/dev/' | awk '{ print $6 "_:_" $5 }')
do

        part=$(echo "$line" | awk -F"_:_" '{ print $1 }')
        part_usage=$(echo "$line" | awk -F"_:_" '{ print $2 }' | cut -d'%' -f1 )

        ## weed out non numbers
        re='^[0-9]+([.][0-9]+)?$'
        if ! [[ $part_usage =~ $re ]];
        then
            	continue
        fi


        if [ $part_usage -ge $THRESHOLD -a -z "$EMAIL" ];
        then
                EMAIL="$(date): Running out of inodes on $HOSTNAME\n"
                EMAIL="$EMAIL\n$part ($part_usage%) >= (Threshold = $THRESHOLD%)"

        elif [ $part_usage -ge $THRESHOLD ];
        then
                EMAIL="$EMAIL\n$part ($part_usage%) >= (Threshold = $THRESHOLD%)"
        fi
done

if [ -n "$EMAIL" ];
then
        echo -e "$EMAIL" | $MAIL -s "ALERT: $HOSTNAME inodes" "$ADMIN"
fi