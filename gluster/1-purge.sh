#!/bin/bash -x
#bdereims@gmail.com

. ../env
. ../functions.sh

HOST_NUM=3
node_list NODES
declare -p NODES

gluster volume stop gv0
gluster volume delete gv0

for i in "${NODES[@]}"
do
	ssh ${i} "rm -fr ${GLUSTER_BRICK}/*"
	ssh ${i} "umount ${GLUSTER_BRICK}"
	ssh ${i} "rm -fr /tmp/${GLUSTER_VOL}"
done

exit 0
