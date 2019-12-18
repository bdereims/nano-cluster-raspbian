#!/bin/bash
#bdereims@gmail.com

. ./env
. ./functions.sh

uninstall_k8s() {
	# Assuming ${HOST_HEADER}1 is the master 

        print_style "Uninstalling k8s" "info"
	MASTER="${HOST_HEADER}1"

	for (( i=${HOST_NUM}; i>=1; i--))
        do
                HOST=${HOST_HEADER}${i}
		print_style "Uninstalling ${HOST}" "info"
		ssh ${HOST} "kubeadm reset -f"
        done

	HOST=${HOST_HEADER}1
	rm -fr ~/.kube
	rm -fr /etc/cni
}

main() {
	uninstall_k8s
}

main
