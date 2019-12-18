#!/bin/bash
#bdereims@gmail.com

mount -t ceph ${HOSTNAME}:6789:/ /mnt/cephfs -o name=admin,secretfile=/root/admin.secret
