#!/bin/bash
#bdereims@gmail.com

. ./env
. ./functions.sh

reboot_hosts() {
	for (( i=${HOST_NUM}; i>=1; i--))
        do
                HOST=${HOST_HEADER}${i}
		print_style "Powering off ${HOST}" "danger"
		ssh ${HOST} "poweroff"
        done
}

main() {
	reboot_hosts
}

main
