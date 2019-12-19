#!/bin/bash
#bdereims@gmail.com

#pushd ~
#wget https://get.helm.sh/helm-v2.14.1-linux-arm.tar.gz
#wget https://get.helm.sh/helm-v3.0.2-linux-arm.tar.gz
#tar xvzf helm-v2.14.1-linux-arm.tar.gz
#tar xvzf helm-v3.0.2-linux-arm.tar.gz
#cp linux-arm/helm /usr/local/bin
#cp linux-arm/tiller /usr/local/bin

#cd -
#kubectl create -f helm-rbac.yanl
#helm --kubeconfig /etc/rancher/k3s/k3s.yaml --tiller-image=jessestuart/tiller init --wait --service-account tiller --upgrade

#helm repo add arm-stable https://peterhuene.github.io/arm-charts/stable

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

helm repo add arm-stable https://peterhuene.github.io/arm-charts/stable
