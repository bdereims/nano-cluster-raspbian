#!/bin/bash
#bdereims@gmail.com

helm install -n nfs-client --namespace nfs-client stable/nfs-client-provisioner --set nfs.server=10.0.0.1 --set nfs.path=/data
kubectl patch storageclass nfs-client -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

