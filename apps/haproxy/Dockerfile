FROM alpine 
MAINTAINER Brice Dereims "bdereims@gmail.com"

# Install HAProxy
RUN apk update && apk upgrade && \
	apk add --no-cache haproxy certbot

# Add HAProxy default config 
ADD haproxy.conf /etc/haproxy/haproxy.conf
ADD haproxy.pem /etc/haproxy/haproxy.pem
RUN mkdir -p /var/lib/haproxy \
	&& chown -R haproxy:haproxy /var/lib/haproxy \ 
	&& chmod 600 /etc/haproxy/*

COPY cert.sh /cert.sh

ADD ./startup.sh /opt/startup.sh

EXPOSE 80 443 9090 

CMD ["/bin/sh", "/opt/startup.sh"]
