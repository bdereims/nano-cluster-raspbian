include ../Makefile.env

CONTAINER_NAME=nextcloud

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
	docker run -d --name $(CONTAINER_NAME) \
	-p 8085:80 \
	-v $(VOLUME):/var/www/html \
	--dns=$(DNS) \
	$(IMAGE_NAME)

stop:
	docker stop $(CONTAINER_NAME) 
	docker rm $(CONTAINER_NAME) 

clean: 
	docker rmi $(IMAGE_NAME) 
	docker images

volume-clean:
	rm -fr $(VOLUME)
