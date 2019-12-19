#!/bin/bash
#bdereims@gmail.com

#helm install -n nfs-client --namespace nfs-client stable/nfs-client-provisioner --set nfs.server=10.0.0.1 --set nfs.path=/data
helm install nfs-client --namespace nfs-client --set nfs.server=172.16.42.1 --set nfs.path=/data stable/nfs-client-provisioner
kubectl patch storageclass nfs-client -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

