make_net_config=./test.txt
ip_gateway=gateway
ip_address=10.10.10.20
get_interface=eth0
docker_env=prod
env_upper=${docker_env^^}
touch $make_net_config
echo "[Match]
Name=$get_interface
[Network]
Address=$ip_address/24
Gateway=$ip_gateway" > $make_net_config
echo test"$env_upper"_lol
mkdir -p test"$env_upper"_lol
nfs_check=cat /etc/fstab | grep BASE | awk '{ print $1 }' > /dev/null

if [ -z $nfs_check ]
then
	echo "something is not here"
fi
echo "something is here"
