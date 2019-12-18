include ../Makefile.env

CONTAINER_NAME=syncthing

IMAGE_NAME=$(HOSTNAME)/$(CONTAINER_NAME)
VOLUME=$(VOLUME_DIR)/$(CONTAINER_NAME)

build: Dockerfile
	docker build -t $(IMAGE_NAME) .

start:
	docker run -d -p 8384:8384 -p 22000:22000 \
	-v ${VOLUME}:/var/syncthing \
	--name ${CONTAINER_NAME} \
	--restart=always \
	${IMAGE_NAME}	

stop:
	docker stop $(CONTAINER_NAME) 
	docker rm $(CONTAINER_NAME) 

clean: 
	docker rmi $(IMAGE_NAME) 
	docker images

clean-volume:
	rm -fr $(VOLUME)/{*,.??*}

