#!/usr/bin/bash

iptables -t nat -A POSTROUTING -o eth0.2 -j MASQUERADE
#mount -t glusterfs localhost:/gv0 /mnt/gv0
#mount -t glusterfs localhost:/gv1 /mnt/gv1
