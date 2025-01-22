#!/bin/bash
#GVEA
#Michael Peterson
#01/20/2025
#Get basic options for a Proton template

read -p 'Enter Hostname: ' host_name
read -p 'IP ADDR: ' ip_address
read -p 'IP Gateway: ' ip_gateway
read -p 'Environment: ' docker_env
read -s -p "Password: " password
read -s -p "Docker auth key: " docker_auth
make_net_config="/etc/systemd/network/10-static-en.network"
env_upper=${docker_env^^}

#Install dependencies
tdnf update -y
tdnf install -y sudo nfs-utils tmux docker-compose git diffutils nc lsof

#Set Hostname
hostnamectl set-hostname $host_name

#Set DNS
grep -q 'gvea.com' /etc/systemd/resolved.conf ||
echo "[Resolve]
DNS=10.254.254.13 10.254.254.14
DNSSEC=no
DNSOverTLS=no
LLMNR=no
Domains=gvea.com gvea.local" > /etc/systemd/resolved.conf
systemctl restart systemd-resolved

#Enable ICMP
iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables-save > /etc/systemd/scripts/ip4save

#NTP and Timezone
echo "[Time]
NTP=pool.ntp.org" > /etc/systemd/timesyncd.conf
ln -sf /usr/share/zoneinfo/America/Anchorage /etc/localtime

#Set passwordless sudo
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo

#User Creation
grep -q 'docker_' /etc/passwd ||
if [[ "$docker_env" == "test" ]]
then 
    /usr/sbin/useradd --comment "Docker $docker_env user" --user-group --groups wheel,docker --create-home --home-dir /home/docker_$docker_env/ --shell /bin/bash docker_$docker_env --uid 5000
elif [[ "$docker_env" == "prod" ]]
then    
    /usr/sbin/useradd --comment "Docker $docker_env user" --user-group --groups wheel,docker --create-home --home-dir /home/docker_$docker_env/ --shell /bin/bash docker_$docker_env --uid 5001
elif [[ "$docker_env" == "test" ]]
then
    /usr/sbin/useradd --comment "Docker $docker_env user" --user-group --groups wheel,docker --create-home --home-dir /home/docker_$docker_env/ --shell /bin/bash docker_$docker_env --uid 5002
elif [[ "$docker_env" == "concourse" ]]
then
    /usr/sbin/useradd --comment "Docker $docker_env user" --user-group --groups wheel,docker --create-home --home-dir /home/docker_$docker_env/ --shell /bin/bash docker_$docker_env --uid 5003
fi
chpasswd <<<"docker_$docker_env:$password"
chage --maxdays -1 root
chage --maxdays -1 docker_$docker_env
mkdir -p /home/docker_$docker_env/.docker
if [ ! -f /home/docker_$docker_env/.docker/config.json ]
then
echo "{
	"auths": {
		"https://index.docker.io/v1/": {
			"auth": "$docker_auth"
		}
	}
}" > /home/docker_$docker_env/.docker/config.json
fi
mkdir -p /home/docker_$docker_env/.ssh
if [ ! -f /home/docker_$docker_env/.ssh/authorized_keys ]
then
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJjM92/BhuAzssMJ9nMJrccngepjZF7IAJ4GOecYjH7e mlk@gvea.com
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImZcu5NmLq2WjSDDCPCPG4TpVBtQqekdyDadOCtmzrY mppeterson@gvea.com" > /home/docker_$docker_env/.ssh/authorized_keys
fi
chmod 700 /home/docker_$docker_env/.ssh
chmod 644 /home/docker_$docker_env/.ssh/authorized_keys
chown -R docker_$docker_env:docker_$docker_env /home/docker_$docker_env/

#NFS Mounts
mkdir -p /mnt/"$env_upper"_DockerNFS1
mkdir -p /docker_data/ 
chown docker_$docker_env:docker_$docker_env /mnt/"$env_upper"_DockerNFS1
chown docker_$docker_env:docker_$docker_env /docker_data
grep -q 'gvea' /etc/fstab ||
    printf "gvea-nfs1.gvea.local:/"$env_upper"_DockerNFS1 /mnt/"$env_upper"_DockerNFS1 nfs defaults 0 0" >> /etc/fstab
mount -a

#Enable and start Docker
systemctl enable docker
systemctl start docker

#Docker Network Config
docker stop $(docker ps -a -q) 
docker network rm $(docker network ls --quiet)
mkdir -p /etc/docker
if [ ! -f /etc/docker/daemon.json ]
then
echo '{
 "bip":"192.168.0.1/24",
 "default-address-pools":[
  {"base":"192.168.1.0/24","size":24},
  {"base":"192.168.2.0/24","size":24},
  {"base":"192.168.3.0/24","size":24}
 ]
}' > /etc/docker/daemon.json
fi
systemctl restart docker
#systemctl status docker

#Update Networking
echo "This will break your SSH sesion, and reboot the VM. Reconnect at $ip_address"
[ ! -f src ] || mv /etc/systemd/network/99-dhcp-en.network /etc/systemd/network/BAK.99-dhcp-en.network
if [ ! -f $make_net_config ]
then
touch $make_net_config
echo "[Match]
Name=eth0
[Network]
Address=$ip_address/24
Gateway=$ip_gateway" > $make_net_config
chmod o+r $make_net_config
systemctl daemon-reload
systemctl restart systemd-networkd 
fi
reboot