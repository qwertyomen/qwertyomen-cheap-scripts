#!/bin/bash
#GVEA
#Michael Peterson
#01/20/2025
#Get basic options for a Proton template

read -p 'Enter Hostname: ' host_name
echo "Include CIDR in IP Address, i.e. 10.40.64.25/24"
read -p 'IP ADDR: ' ip_address
read -p 'IP Gateway: ' ip_gateway
read -p 'Environment: ' docker_env
read -s -p "Password: " password
get_interface='ip addr | grep 2: | awk '{ print $2 }' | sed 's/://g''
make_net_config="/etc/systemd/network/10-static-en.network"

#Set Hostname
hostnamectl set-hostname $host_name

#Update Networking
mv /etc/systemd/network/99-dhcp-en.network /etc/systemd/network/BAK.99-dhcp-en.network
touch $make_net_config
echo "[Match]" >> $make_net_config
echo "Name=$get_interface"  >> $make_net_config
echo "[Network]" >> $make_net_config
echo "Address=$ip_address/24"  >> $make_net_config
echo "Gateway=$ip_gateway" >> $make_net_config
chmod o+r $make_net_config
systemctl daemon-reload
systemctl restart systemd-networkd 

#Set DNS
echo "search gvea.com gvea.local" >> /etc/systemd/resolved.conf
echo DNS=10.254.254.13 10.254.254.14 >> /etc/systemd/resolved.conf
systemctl restart systemd-resolved

#Enable ICMP
iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables-save >/etc/systemd/scripts/ip4save

#NTP and Timezone
echo "NTP=pool.ntp.org" >> /etc/systemd/timesyncd.conf
ln -sf /usr/share/zoneinfo/America/Anchorage /etc/localtime

#User Creation
/usr/sbin/useradd --comment "Purpose of the user" --user-group --groups wheel,docker --create-home --home-dir /home/docker_$docker_env/ --shell /bin/bash docker_$docker_env --uid 500x
password docker_$docker_env $password
chage --maxdays -1 root
chage --maxdays -1 docker_$docker_env

#Install sudo
tdnf install -y sudo
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo

