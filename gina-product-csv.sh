#Hunts through the ldm-products.csv and lists products by:
#satellite reciever location
#satellite, sensor, and band
#author: qwertyomen - 2024
source="ldm-products.csv"
sat=$(cat $source | tr _ ' ' | awk '{ print $3 }' | sort -u)

for i in $sat
do
    cat $source | tr _ ' ' | grep $i | awk '{ print $1,$2,$3,$4,$5,$6 }' | sort -u | tr ' ' _ > all.csv
done

#for m in "${sat[@]}"
#do
#        echo $m
#done