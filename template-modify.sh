#!/bin/bash
#GVEA
#Michael Peterson
#12/17/2024
#Get basic options for a VM template

read -p 'Enter Hostname: ' host_name
echo "Include CIDR in IP Address, i.e. 10.40.64.25/24"
read -p 'IP ADDR: ' ip_address
read -p 'IP Gateway: ' ip_gateway

#Set Hostname
hostnamectl set-hostname $host_name

#Set IP
echo "search gvea.com gvea.local" >> /etc/resolv.conf
nmcli con modify ens192 ipv4.address $ip_address ipv4.gateway $ip_gateway ipv4.dns "10.254.254.13 10.254.254.14"
service NetworkManager restart

#Enable ICMP
iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables-save >/etc/systemd/scripts/ip4save