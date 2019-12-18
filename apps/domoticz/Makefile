include ../Makefile.env

CONTAINER_NAME=domoticz

IMAGE_NAME=$(HOSTNAME)/$(CONTAINER_NAME)
VOLUME=$(VOLUME_DIR)/$(CONTAINER_NAME)

build: Dockerfile
	docker build -t $(IMAGE_NAME) .

start:
	docker run -d \
	--name $(CONTAINER_NAME) \
	-e TZ=Europe/Paris \
	-v /etc/localtime:/etc/localtime:ro \
	-p 8080:8080 \
	-p 4443:443 \
	-p 6144:6144 \
	-v $(VOLUME):/config \
	--device /dev/ttyUSB0 \
	--device /dev/ttyACM0 \
	--restart unless-stopped \
	$(IMAGE_NAME)

stop:
	docker stop $(CONTAINER_NAME) 
	docker rm $(CONTAINER_NAME) 

clean: 
	docker rmi $(IMAGE_NAME) 
	docker images

clean-volume:
	rm -fr $(VOLUME)/{*,.??*}

