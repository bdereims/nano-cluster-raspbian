#!/bin/bash
#bdereims@gmail.com

. ../env
. ../functions.sh

HOST_NUM=3
node_list NODES
declare -p NODES

cd ~/ceph-deploy 
ceph-deploy purge "${NODES[@]}" 
ceph-deploy purgedata "${NODES[@]}"
ceph-deploy forgetkeys
rm ceph.*
cd -

for i in "${NODES[@]}"
do
	scp lvm-clean.sh ${i}:./lvm-clean.sh
	ssh ${i} "bash lvm-clean.sh"
done

exit 0

# dmsetup info -C
# dmsetup remove [dm_map_name]
# delete lvs/vgs/pv with --force

for i in "${NODES[@]}"
do
	#ssh ${i} "lvremove --force $(lvs | grep ceph | awk '{print \$2\" \"\$1}')"
	#ssh ${i} "vgremove $(vgs | grep ceph | awk '{print \$1}')"
	#ssh ${i} "pvremove $(pvs | grep dev | awk '{print \$1}')"
	ssh ${i} "dd if=/dev/zero of=/dev/mmcblk0p3 bs=1024 count=1024"
done
