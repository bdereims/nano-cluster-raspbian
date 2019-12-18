include ../Makefile.env

CONTAINER_NAME=registry

IMAGE_NAME=$(HOSTNAME)/$(CONTAINER_NAME)
VOLUME=$(VOLUME_DIR)/$(CONTAINER_NAME)
VERSION=2
PORT=4443

build:
	docker pull $(CONTAINER_NAME):$(VERSION)
	docker tag $(CONTAINER_NAME):$(VERSION) $(IMAGE_NAME) 
	mkdir -p $(VOLUME)/data
	mkdir -p $(VOLUME)/certs
	openssl req  -newkey rsa:2048 -nodes -sha256 \
		-keyout $(VOLUME)/certs/domain.key \
		-x509 -days 3650 \
		-out $(VOLUME)/certs/domain.crt
	mkdir -p /etc/docker/certs.d/$(HOSTNAME):$(PORT)
	cp $(VOLUME)/certs/domain.crt /etc/docker/certs.d/$(HOSTNAME):$(PORT)/ca.crt
	cp $(VOLUME)/certs/domain.crt /usr/local/share/ca-certificates/ca.crt
	update-ca-certificates

start:
	docker run -d \
	--restart=always \
	-p 5000:5000 \
	-p $(PORT):443 \
	-v $(VOLUME)/data:/var/lib/registry \
	-v $(VOLUME)/certs:/certs \
	-e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
	-e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
	-e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
	--name $(CONTAINER_NAME) \
	$(IMAGE_NAME) 

stop:
	docker stop $(CONTAINER_NAME) 
	docker rm $(CONTAINER_NAME) 

clean: 
	docker rmi $(IMAGE_NAME) --force 
	docker images

clean-volume:
	rm -fr $(VOLUME)/(*,.??*)

