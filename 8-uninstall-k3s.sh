#!/bin/bash
#bdereims@gmail.com

. ./env
. ./functions.sh

uninstall_k3s() {
	# Assuming ${HOST_HEADER}1 is the master 

        print_style "Uninstalling k3s" "info"
	MASTER="${HOST_HEADER}1"

	for (( i=${HOST_NUM}; i>=2; i--))
        do
                HOST=${HOST_HEADER}${i}
		print_style "Uninstalling ${HOST}" "info"
        	ssh ${HOST} "/usr/local/bin/k3s-uninstall.sh"
        	ssh ${HOST} "/usr/local/bin/k3s-agent-uninstall.sh"
        done

	HOST=${HOST_HEADER}1
	print_style "Uninstalling ${HOST}" "info"
	ssh ${HOST} "/usr/local/bin/k3s-uninstall.sh"
}

main() {
	uninstall_k3s
}

main
