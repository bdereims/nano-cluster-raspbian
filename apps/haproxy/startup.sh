#!/bin/sh

#/usr/sbin/apache2ctl start
./cert.sh
cat /etc/letsencrypt/live/darkness.blue-tale.net/fullchain.pem /etc/letsencrypt/live/darkness.blue-tale.net/privkey.pem > /etc/haproxy/haproxy.pem
/usr/sbin/haproxy -d -f /etc/haproxy/haproxy.conf -p /var/run/haproxy.pid
