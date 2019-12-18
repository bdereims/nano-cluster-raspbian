#!/bin/bash
#bdereims@gmail.com

. ./env
. ./functions.sh

update_localhost() {
	print_style "Updating localhost" "info"
        apt-get update
        apt-get -y upgrade

        apt-get -y install sshpass tmux dnsmasq hostapd

	systemctl unmask hostapd
}

update_key() {
	FILE=~/.ssh/known_host
	[ -e ${FILE} ] && rm ${FILE} 

	[ ! -e ~/.ssh/id_rsa.pub ] && cat /dev/zero | ssh-keygen -t rsa -b 4096 -q -N "" > /dev/null
	cat authorized_keys ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys

	for (( i=1; i<=${HOST_NUM}; i++)) 
	do
		HOST=${HOST_HEADER}${i}
		print_style "Updating authorized key for ${HOST}" "info"
		remote_cp "/root/.ssh/authorized_keys" "${DEFAULT_USER}@${HOST_HEADER}${i}:~/."
		remote_exec ${HOST_HEADER}${i} "sudo mkdir -p /root/.ssh ; sudo cp authorized_keys /root/.ssh/authorized_keys ; rm authorized_keys"
	done
}

update_hosts() {
	for (( i=1; i<=${HOST_NUM}; i++))
        do
                HOST=${HOST_HEADER}${i}
		print_style "Updating system for ${HOST}" "info"
		ssh ${HOST} "sed -i \"s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/\" /etc/sysctl.conf"
		ssh ${HOST} "sed -i \"s/rootfstype=ext4 elevator=deadline/rootfstype=ext4 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory elevator=deadline/\" /boot/cmdline.txt"
		ssh ${HOST} "grep gpu /boot/config.txt > /dev/null || echo \"gpu_mem=16\" >> /boot/config.txt"
		ssh ${HOST} "apt-get update ; apt-get -y upgrade ; apt-get install -y ntp ntpdate python3-pip xfsprogs"
		ssh ${HOST} "systemctl start ntp ; systemctl enable ntp"
		ssh ${HOST} "dphys-swapfile swapoff ; systemctl stop dphys-swapfile ; systemctl disable dphys-swapfile ; dphys-swapfile uninstall"
		ssh ${HOST} "systemctl disable bluetooth ; systemctl disable avahi-daemon"
		add_to_file ${HOST} "vm.swappiness=1" /etc/sysctl.conf
		add_to_file ${HOST} "vm.min_free_kbytes=32768" /etc/sysctl.conf
		add_to_file ${HOST} "kernel.pid_max=32768" /etc/sysctl.conf
		add_to_file ${HOST} "net.bridge.bridge-nf-call-iptables=1" /etc/sysctl.conf
		add_to_file ${HOST} "net.ipv4.ip_nonlocal_bind=1" /etc/sysctl.conf
		#ssh ${HOST} "apt-get -y install glusterfs-server"
		#ssh ${HOST} "apt-get -y install ceph ceph-deploy lvm2 rbd-nbd"
		ssh ${HOST} "apt-get -y autoremove"
        done
}

update_interfaces() {
	print_style "Updating cluster networking" "info"
	for (( i=1; i<=${HOST_NUM}; i++))
        do
                HOST=${HOST_HEADER}${i}
		print_style "configuring interfaces for ${HOST}" "info"
		eval "echo \"$(< network/template-interfaces)\"" > $$
		scp $$ ${HOST}:/etc/network/interfaces 2>&1 >/dev/null
		ssh ${HOST} "systemctl disable dhcpcd ; systemctl enable systemd-networkd"
		rm $$
	done
}

update_hosts_file() {
	for (( i=1; i<=${HOST_NUM}; i++))
        do
                HOST=${HOST_HEADER}${i}
		print_style "configuring hosts list for ${HOST}" "info"
		for (( j=1; j<=${HOST_NUM}; j++))
        	do
			add_to_file ${HOST} "${VLAN_SUBNET}.${j}\t${HOST_HEADER}${j}" /etc/hosts				
		done	
	done
}

update_kernel() {
	for (( i=1; i<=${HOST_NUM}; i++))
        do
                HOST=${HOST_HEADER}${i}
		print_style "Updating kernel for ${HOST}" "info"
		scp kernel/kernel.tgz ${HOST}:/
		ssh ${HOST} "cd / ; tar xvzf kernel.tgz ; rm kernel.tgz"
	done
}


main() {
	update_localhost
	update_key
	update_hosts
	update_interfaces
	update_hosts
	update_hosts_file
	#update_kernel

	print_style "You should reboot the cluster (no action is done here, do it by yourself)" "info"
}

main
