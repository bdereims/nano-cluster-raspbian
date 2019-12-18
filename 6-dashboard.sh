#!/bin/bash
#bdereims@gmail.com

curl https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml | sed -e "s/amd64/arm/" | kubectl apply -f -

watch kubectl get po,svc,deploy,ingress -o wide --all-namespace
