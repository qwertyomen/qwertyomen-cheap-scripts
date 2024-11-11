#!/bin/bash
# Program name: diglist.sh
URL="url.com"
date
cat ./diglist.csv |  while read output
do
    dig -x "$output" | grep $URL | awk '{print $1,","$5 }' >> diglistresult.csv
#    if [ $? -eq 0 ]; then
#    echo "$output"
#    else
#    echo "node $output is down"
#    fi
done