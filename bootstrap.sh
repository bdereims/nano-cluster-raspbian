#!/bin/bash
#bdereims@gmail.com

main() {
	apt-get -y install git dnsmasq hostapd tmux
	cd /
	git clone https://github.com/bdereims/nano-cluster	
}

main
