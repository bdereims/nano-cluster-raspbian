#!/bin/bash
#bdereims@gmail.com

. ./env
. ./functions.sh

node_list NODES
declare -p NODES

install_k3s_master() {
	print_style "Installing Kubernetes master through k3s" "info"
	curl -sfL https://get.k3s.io | sh -

	mkdir -p ~/.kube
	cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
}

install_k3s_worker() {
	# Assuming ${HOST_HEADER}1 is the master 

        print_style "Installing Kubernetes workers through k3s" "info"
	MASTER="${HOST_HEADER}1"
	TOKEN=$(cat /var/lib/rancher/k3s/server/node-token)

	for (( i=${HOST_NUM}; i>=2; i--))
        do
                HOST=${HOST_HEADER}${i}
		print_style "Modifying ${HOST} as Kubernetes worker" "info"
        	ssh ${HOST} "curl -sfL https://get.k3s.io | K3S_TOKEN=${TOKEN} K3S_URL=https://${MASTER}:6443 sh -"
        done
}

label_nodes() {
	print_style "Labeling nodes" "info"

	for i in "${NODES[@]}"
	do
		TYPE=$(ssh ${i} "cat /sys/firmware/devicetree/base/model" | sed -e "s/ /-/g")
		print_style "Labeling ${i} with ${TYPE}" "info"
		kubectl label --overwrite nodes ${i} model="${TYPE}"
	done
}

main() {
	install_k3s_master
	install_k3s_worker
	label_nodes
}

main
