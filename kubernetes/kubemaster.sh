#!/bin/bash
#bdereims@gmail.com

MYIP=$( host ${HOSTNAME} | sed "s/^.*address //" )

kubeadm init --apiserver-advertise-address=${MYIP} --pod-network-cidr=10.244.0.0/16
kubectl taint nodes --all node-role.kubernetes.io/master-
