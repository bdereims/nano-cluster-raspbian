#!/bin/bash
#bdereims@gmail.com

. ./env
. ./functions.sh

test_k8s() {
	NAMESPACE=nginx
	kubectl create namespace ${NAMESPACE} 
	kubectl -n ${NAMESPACE} create deployment  mynginx --image=nginx 
	kubectl -n ${NAMESPACE} expose deployment mynginx --port 80 --type=LoadBalancer
	watch kubectl get po,svc,deploy -o wide --all-namespaces
}

main() {
	test_k8s
}

main
