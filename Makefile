DOCKER_NAME=dev-machine

.PHONY: all build run help

all: help

build: ## Build the docker
	@docker build --tag=$(DOCKER_NAME) .

run: ## Run the docker
	@docker run --rm -ti \
		--name=${PROJECT_NAME}-dev \
		--env SET_SUBLIME=${SET_SUBLIME} \
		--volume=${WORK_FOLDER}:/home/devuser/work \
		$(DOCKER_NAME)

help: ## Display this help screen
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
