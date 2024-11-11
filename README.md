# cheap-scripts
Cheap scripts because I haven't polished them. Some work crudely, some don't even work.

Virsh VCPU Count:
To get a count of the VCPUs in use on a compute node run:
sudo bash vm-cpu-count.sh | wc -l

Virsh Vmemory Count:
(It comes out in KiB or something dumb like that)
sudo bash vm-mem-count.sh | awk '{total += $2}END{ print total }'
