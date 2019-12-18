#!/bin/bash
#bdereims@gmail.com

HERE=$(pwd)

cd /
tar cvzf ${HERE}/4.19.57-v7l+.tgz /boot/kernel7l.img /boot/*.dtb /boot/overlays /lib/modules/4.19.57-v7l+
