include ../Makefile.env

CONTAINER_NAME=haproxy

IMAGE_NAME=$(HOSTNAME)/$(CONTAINER_NAME)
VOLUME=$(VOLUME_DIR)/$(CONTAINER_NAME)

vars:
	@echo $(CONTAINER_NAME)
	@echo $(IMAGE_NAME)
	@echo $(VOLUME)
	@echo $(DNS)

build: Dockerfile
	docker build -t $(IMAGE_NAME) .

start:
	mkdir -p $(VOLUME)
	docker run -d \
	--net=host \
	--dns=$(DNS) \
	--name $(CONTAINER_NAME) $(IMAGE_NAME)

stop:
	docker stop $(CONTAINER_NAME) 
	docker rm $(CONTAINER_NAME) 

clean: 
	docker rmi $(IMAGE_NAME) 
	docker images

volume-clean:
	rm -fr $(VOLUME)
