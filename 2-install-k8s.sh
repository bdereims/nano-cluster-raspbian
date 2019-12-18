#!/bin/bash
#bdereims@gmail.com

. ./env
. ./functions.sh

node_list NODES
declare -p NODES

install_prereqs() {
        print_style "Installing Kubernetes prereqs" "info"

        for (( i=1; i<=${HOST_NUM}; i++))
        do
                HOST=${HOST_HEADER}${i}
                print_style "Updating ${HOST}" "info"

		#ssh ${HOST} "curl -sSL https://get.docker.com | sh"
		remote_cp "daemon.json" "${HOST}:/etc/docker/daemon.json"
		ssh ${HOST} "mkdir -p /etc/systemd/system/docker.service.d ; systemctl daemon-reload ; systemctl restart docker"

		ssh ${HOST} "apt-get update && sudo apt-get install -y apt-transport-https curl"
		ssh ${HOST} "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -"
		ssh ${HOST} "echo \"deb https://apt.kubernetes.io/ kubernetes-xenial main\" > /etc/apt/sources.list.d/kubernetes.list"
		ssh ${HOST} "apt-get update ; apt-get install -y kubelet kubeadm kubectl --allow-change-held-packages ; apt-mark hold kubelet kubeadm kubectl"
        done
}

install_k8s_master() {
	# Assuming ${HOST_HEADER}1 is the master 
	MASTER="${HOST_HEADER}1"

	print_style "Configuring ${MASTER} as Kubernetes master" "info"

	#ADDRIP=$( host ${HOSTNAME} | sed -e "s/^.*address//" -e "s/ //g" )
	ADDRIP=$( ping -c 1 ${HOSTNAME} | head -1 | sed -e "s/^.* (//" -e "s/).*$//" )
	OUTPUT=$( kubeadm init --apiserver-advertise-address=${ADDRIP} --pod-network-cidr=10.244.0.0/16 )
	WORKER=$( echo $OUTPUT | sed -e 's/^.*on each as root: //' -e 's/\\//g' )

	mkdir -p $HOME/.kube
	cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	chown $(id -u):$(id -g) $HOME/.kube/config
}

install_k8s_worker() {
	for (( i=${HOST_NUM}; i>=2; i--))
        do
                HOST=${HOST_HEADER}${i}
        	print_style "Configuring ${HOST} as Kubernetes worker" "info"
		
		ssh ${HOST} "${WORKER}"
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

	kubectl taint nodes ${NODES[0]} node-role.kubernetes.io/master=true:NoSchedule
}

setup_k8s() {
	kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
	kubectl apply -f metallb-0.8.yaml
	kubectl apply -f metallb-configmap.yaml
}

main() {
	install_prereqs
	install_k8s_master
	install_k8s_worker
	setup_k8s
	#label_nodes
}

main
