#!/bin/bash
#bdereims@gmail.com

. ../env
. ../functions.sh

HOST_NUM=3
node_list NODES
declare -p NODES

print_style "Phase 1 - initializing" "info"

for i in "${NODES[@]}"
do
	gluster peer probe ${i}
done

print_style "Peer Status" "info"
gluster peer status


print_style "Phase 2 - creating brick" "info"

BRICKS=""

for i in "${NODES[@]}"
do
	print_style "brick for ${i}" "info"
	ssh ${i} "mkfs.xfs -f -i size=512 -n size=8192 -d su=128k,sw=10 ${GLUSTER_DISK}"
	ssh ${i} "mkdir -p ${GLUSTER_BRICK}"
	ssh ${i} "mount ${GLUSTER_DISK} ${GLUSTER_BRICK}"
	BRICKS="${i}:${GLUSTER_BRICK}/${GLUSTER_VOL} "+${BRICKS}
done

print_style "Phase 3 - creating volume" "info"

gluster volume create ${GLUSTER_VOL} ${BRICKS} 
gluster volume start ${GLUSTER_VOL}

mkdir -p /mnt/${GLUSTER_VOL}
mount -t glusterfs ${HOSTNAME}:/${GLUSTER_VOL} /mnt/${GLUSTER_VOL}
