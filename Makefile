APP		:= flask-app
USER		:= xomodo
IMAGE		= $(USER)/$(APP)

#TAG 		:= $(shell git describe --tags --exact-match)
TAG		:= $(shell git log -1 --pretty=format:%h)

DOCKER		:= docker
DOCKER-COMPOSE	:= docker-compose

ifeq ($(shell which $(DOCKER) >/dev/null 2>&1; echo $$?), 1)
$(error The '$(DOCKER)' command was not found. Make sure you have '$(DOCKER)' installed, then set the DOCKER environment variable to point to the full path of the '$(DOCKER)' executable.)
endif

ifeq ($(shell which $(DOCKER-COMPOSE) >/dev/null 2>&1; echo $$?), 1)
$(error The '$(DOCKER-COMPOSE)' command was not found. Make sure you have '$(DOCKER-COMPOSE)' installed, then set the DOCKER-COMPOSE environment variable to point to the full path of the '$(DOCKER-COMPOSE)' executable.)
endif

# Build the base docker image which is shared between the development and production images
base:
	@echo "Building $(IMAGE):$(TAG)"
	${DOCKER} build -t $(IMAGE):$(TAG) -f Dockerfile .

# Build the development docker image
build: base
	$TAG=$(TAG) ${DOCKER-COMPOSE} build

# Run the development environment in the background
start: build
	TAG=${TAG} ${DOCKER-COMPOSE} up -d

# Stop the development environment (background and/or foreground)
stop:
	TAG=${TAG} ${DOCKER-COMPOSE} stop; \
        ${DOCKER-COMPOSE} rm -f;

BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
COMMIT=$(shell git rev-parse --short HEAD)

# Build the production image
image: base
	${DOCKER} build \
	--label revision=$(COMMIT) \
	--label branch=$(BRANCH) \
	-t $(IMAGE):latest \
	-f Dockerfile \
	./
	
clean:
	${DOCKER} rm -f $(IMAGE):$(TAG)

push:
	@echo "Pushing $(IMAGE):$(TAG)"
	${DOCKER} push $(IMAGE):$(TAG)
	echo "Consider also: make push-latest"

push-latest:
	${DOCKER} tag $(IMAGE):$(TAG) $(IMAGE):latest
	${DOCKER} push $(IMAGE):latest
