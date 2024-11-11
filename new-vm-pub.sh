#!/bin/bash
#Author: Michael Peterson - 2024

#read -p 'Enter hostname (Add .x for internal vms): ' 
vm_name=VM-NAME
if ! test -f /var/lib/libvirt/images/local-os/$vm_name.img; then
#read -p 'IP Address: ' 
ip=IP ADDR
#read -p 'vlan (19 for Public, 819 for internal): ' 
vlan=19
#read -p 'Gateway (137.229.19.1 - Public, 10.19.16.1 - Local): ' 
gateway=IP ADDR
#read -p 'Base disk image size (GB): ' 
size_base=180
#read -p 'Scratch disk size (GB): ' size_scratch
#read -p 'RAM amount (in MB): ' 
ram=65536
#read -p 'CPU Count (Cores): ' 
cpu=8
#read -p 'kickstart file: ' 
kickstart=http://kickstart.rcs.alaska.edu/rpmrepo/ks/centos8-server-template-vm.cfg
rocky_version=9

virt-install --connect=qemu:///system --network=bridge:br$vlan --extra-args="inst.ks=$kickstart console=tty0 console=ttyS0,115200 ip=$ip::$gateway:255.255.255.0:$vm_name.gina.alaska.edu:enp1s0:none nameserver=8.8.8.8" --name=$vm_name --disk /var/lib/libvirt/images/local-os/$vm_name.img,size=$size_base --ram=$ram --vcpus=$cpu --check-cpu --accelerate --hvm --location=http://mirrors.rcs.alaska.edu/rocky/$rocky_version/BaseOS/x86_64/os --nographics --os-variant=rocky$rocky_version --check disk_size=on

else
        echo "$vm_name already exists"
fi