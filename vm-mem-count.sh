#! /bin/env/bash
#author: qwertyomen - 2024
vm=($(virsh list | awk 'NR>2 { print $1 }'))

for m in "${vm[@]}"
do
        virsh dommemstat "${m}" | grep available
done

