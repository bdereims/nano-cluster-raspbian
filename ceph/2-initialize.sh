#!/bin/bash
#bdereims@gmail.com

. ../env
. ../functions.sh

CEPH_DIR="/root/ceph-deploy"
CEPH_NET="10.0.0.0/24"
CEPH_DISK="/dev/mmcblk0p3"

mkdir -p ${CEPH_DIR} 
cd ${CEPH_DIR} 

HOST_NUM=3
node_list NODES
declare -p NODES

print_style "Phase 1 - initializing" "info"

ceph-deploy new "${NODES[0]}" --public-network ${CEPH_NET} 
ceph-deploy install "${NODES[@]}" 
ceph-deploy mon create-initial
ceph-deploy --overwrite-conf admin "${NODES[@]}" 
ceph-deploy mgr create "${NODES[0]}" 

print_style "Phase 2 - creating OSDs" "info"

for i in "${NODES[@]}"
do
	#scp /var/lib/ceph/bootstrap-mgr/ceph.keyring ${i}:/var/lib/ceph/bootstrap-mgr/ceph.keyring
	ceph-deploy osd create --data ${CEPH_DISK} "${i}" 
done

print_style "Phase 3 - extending" "info"

ceph-deploy mds create "${NODES[0]}" 

for i in "${NODES[@]}"
do
	ceph-deploy mon add "${i}" 
	ceph-deploy mgr create "${i}"
done

print_style "Phase 4 - finializing" "info"

ceph-deploy rgw create "${NODES[0]}" 

ceph tell mon.\* injectargs '--mon-allow-pool-delete=true'

# ceph osd pool create cephfs_data 64
# ceph osd pool create cephfs_metadata 64
# ceph fs new mycephfs cephfs_metadata cephfs_data

# ceph osd pool create rbd 64
# rbd create -p rbd --size 3G kube
# rbd-nbd map rbd/kube
# mkfs.ext4 /dev/nbd0
# mount /dev/nbd0 /mnt/kube

cd -
