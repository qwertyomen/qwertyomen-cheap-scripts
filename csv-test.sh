#!/bin/bash
#author: qwertyomen - 2024
org_fqdn="org.domain.name"
org_dns="org.primary.dns.ip"
csv_source=vms.csv
while IFS="," read -r ca cb cc cd ce cf cg ch ci cj ck cl cm
do
    c_node="${cb}"
    vm_name="${cc}"
    vm_cpu="${cf}"
    vm_ram="${cg}"
    vm_storage="${ch}"
    vm_scratch="${ci}"
    vm_ip="${cj}"
    vm_sub="${ck}"
    vm_gate="${cl}"
    vm_os="${cm}"
    install_sequence="virt-install --connect=qemu:///system --network=bridge:br$vm_sub --extra-args="inst.ks"=$kickstart" console=tty0 console=ttyS0,115200 ip=$vm_ip::$vm_gateway:255.255.255.0:$vm_name.$org_fqdn:enp1s0:none nameserver=$org_dns" --name=$vm_name --disk /var/lib/libvirt/images/local-os/$vm_name.img,size=$vm_storage --ram=$vm_ram --vcpus=$vm_cpu --check-cpu --accelerate --hvm --location=http://mirrors.rcs.alaska.edu/rocky/$vm_os/BaseOS/x86_64/os --nographics --os-variant=rocky$vm_os --check disk_size=on < /dev/null"
#Debug
#    echo 'c_node    $vm_name $vm_cpu $vm_ram $vm_storage $vm_scratch $vm_ip $vm_sub $vm_gate $vm_os'
#    echo "$c_node   $vm_name $vm_cpu $vm_ram $vm_storage $vm_scratch $vm_ip $vm_sub $vm_gate $vm_os"
    ssh $c_node "hostname" < /dev/null
#    tmux has-session -t $vm_name 2>/dev/null
#    if [ $? != 0 ]; then
#        echo "Session $vm_name already exists."
#    else
#    ssh $c_node tmux list-sessions | grep $c_node
    echo "Creating $vm_name"
    ssh $c_node tmux new-session -d -s $vm_name < /dev/null
    ssh $c_node tmux rename-window -t 0 "$vm_name" < /dev/null
#    ssh $c_node tmux send-keys -t $vm_name "top" < /dev/null
    ssh $c_node tmux send-keys -t "$vm_name" echo Space $install_sequence

done < $csv_source