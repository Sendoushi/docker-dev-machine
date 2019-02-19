DOCKER_NAME=dev-machine
XSOCK=/tmp/.X11-unix
XAUTH=.x11dockerize

.PHONY: all build run help

all: help

build: ## Build the docker
	@docker build --tag=$(DOCKER_NAME) .

run: ## Run the docker
	# Setup X11 server bridge between host and container
	@touch "$(PWD)/$(XAUTH)"
	@xauth nlist "${DISPLAY}" | sed -e 's/^..../ffff/' | xauth -f "$(XAUTH)" nmerge -
	@chmod 644 "$(PWD)/$(XAUTH)" # not the most secure way, USE INSTEAD sublime cli
	@docker run --rm -ti \
		--name=${PROJECT_NAME}-$(shell date +"%s")-dev \
		--volume=${WORK_FOLDER}:/home/devuser/work \
		--volume="$(XSOCK)":"$(XSOCK)":ro \
		--volume="$(PWD)/$(XAUTH)":"$(PWD)/$(XAUTH)":ro \
		--env="XAUTHORITY=$(PWD)/$(XAUTH)" \
		--env="DISPLAY" \
		$(DOCKER_NAME)

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
