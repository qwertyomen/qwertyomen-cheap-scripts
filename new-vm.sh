#!/bin/bash
#Author: Michael Peterson - 2024

read -p 'Enter hostname: ' vm_name
if ! test -f /var/lib/libvirt/images/local-os/$vm_name.img; then
read -p 'Domain Name: ' fqdn
read -p 'IP Address: ' ip
read -p 'vlan: ' vlan
read -p 'Gateway IP: ' gateway
read -p 'Base disk image size (GB): ' size_base
#read -p 'Scratch disk size (GB): ' size_scratch
read -p 'RAM amount (in MB): ' ram
read -p 'CPU Count (Cores): ' cpu
read -p 'kickstart file: ' kickstart
read -p 'Rocky version, 8 or 9: ' rocky_version

virt-install --connect=qemu:///system --network=bridge:br$vlan --extra-args="inst.ks=$kickstart console=tty0 console=ttyS0,115200 ip=$ip::$gateway:255.255.255.0:$vm_name$fqdn:enp1s0:none nameserver=8.8.8.8" --name=$vm_name --disk /var/lib/libvirt/images/local-os/$vm_name.img,size=$size_base --ram=$ram --vcpus=$cpu --check-cpu --accelerate --hvm --location=http://mirrors.rcs.alaska.edu/rocky/$rocky_version/BaseOS/x86_64/os --nographics --os-variant=rocky$rocky_version --check disk_size=on

else
        echo "$vm_name already exists"
fi