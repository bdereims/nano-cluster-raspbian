#!/bin/bash
#bdereims@gmail.com

. ../env
. ../functions.sh

CEPH_DISK="/mnt/cephdisk"
CEPH_FS="/mnt/cephfs"
CEPH_SECRET="/root/admin.secret"

print_style "Creating Ceph Objects" "info"

ceph osd pool create cephfs_data 64
ceph osd pool create cephfs_metadata 64
ceph fs new cephfs cephfs_metadata cephfs_data
ceph auth get client.admin | grep key | sed "s/.*key = //" > ${CEPH_SECRET}
mkdir -p ${CEPH_FS}
mount -t ceph ${HOSTNAME}:6789:/ ${CEPH_FS} -o name=admin,secretfile=${CEPH_SECRET}

exit 0

ceph osd pool create rbd 64
rbd create -p rbd --size 3G kube
rbd-nbd map rbd/kube
mkfs.ext4 /dev/nbd0
mkdir -p ${CEPH_DISK}
mount /dev/nbd0 ${CEPH_DISK} 
