#!/bin/bash
#bdereims@gmail.com

MYIP=$( host ${HOSTNAME} | sed "s/^.*address //" )

apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

#kubeadm init --apiserver-advertise-address=${MYIP} --pod-network-cidr=10.244.0.0/16
#kubectl taint nodes --all node-role.kubernetes.io/master-
