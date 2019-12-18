#!/bin/bash
#bdereims@gmail.com


pushd ~
git clone https://github.com/kubernetes-incubator/metrics-server
cd metrics-server/deploy
sed -i "s/amd64:/arm:/" 1.8+/metrics-server-deployment.yaml
kubectl apply -f 1.8+/
popd
kubectl patch -n kube-system deployment metrics-server --patch "$(cat patch-metric-server.yaml)"

watch kubectl get po,svc,deploy,ingress -o wide --all-namespaces
