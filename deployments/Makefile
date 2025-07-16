.DEFAULT_GOAL := help

.PHONY: clean delete

SHELL=bash
export DIFF_PROGRAM:=vimdiff

# Containerization Parameters
export CONTAINER_BIN=docker
export CONTAINER_COMPOSE=${CONTAINER_BIN} compose
export DEFAULT_IMAGE_REGISTRY=docker.io/library/

DOCKER_DIR=./docker
K8S_DIR=./kubernetes
export DOCKERFILE=${DOCKER_DIR}/Dockerfile

GIT_BRANCH_ME=$(shell git rev-parse --abbrev-ref HEAD)

# Generally this is empty unless in specific environments
ENVIRO_FILE=./.env

VOLUME_MAVEN_SETTINGS_PATH=""

# To set default settings.xml and essentially empty for mvn, unless in vmmoc
$(shell echo "<settings><proxies></proxies></settings>" > ${DOCKER_DIR}/settings.xml)
export GIT_URL=https://github.com/yamcs/yamcs
export GIT_BRANCH=master
$(shell touch ${ENVIRO_FILE})
export MAVEN_HTTPS_PROXY="--settings ./settings.xml"
export HTTPS_PROXY=
export HTTP_PROXY=
export NO_PROXY=localhost

export HEALTHCHECK_PORT=60000

export YAMCS_PORT=8090
export YAMCS_TAG=ghcr.io/haisamido/yamcs:${GIT_BRANCH_ME}

#export M2_HOME=/opt/maven
#export PATH=${M2_HOME}/bin:${PATH}

#---
ifndef DEPLOYMENT_ENVIRO
$(warning DEPLOYMENT_ENVIRO is not set. Therefore, assuming not in vmmoc, and proceeding without vmmoc specific definitions)
else
ifeq (${DEPLOYMENT_ENVIRO},vmmoc)
$(info DEPLOYMENT_ENVIRO is set to vmmoc. Proceeding with vmmoc specific configurations)
export ENVIRO_FILE=/opt/vmmoc/etc/environment
include ${ENVIRO_FILE}
$(shell cp -f ${MAVEN_SETTINGS_FILE} ${DOCKER_DIR}/settings.xml)
else
$(error DEPLOYMENT_ENVIRO is set to ${DEPLOYMENT_ENVIRO}, which is not expected. Exiting!)
endif
endif
#---

down: ## Bring down yamcs
	cd ${DOCKER_DIR} && ${CONTAINER_COMPOSE} down || true

pull-yamcs:
	docker pull ${YAMCS_TAG}

build-yamcs: ## build-yamcs
	touch ${ENVIRO_FILE} && source ${ENVIRO_FILE} ; \
	cd ${DOCKER_DIR} && ${CONTAINER_BIN} build \
		--build-arg GIT_URL=${GIT_URL} \
		--build-arg GIT_BRANCH=${GIT_BRANCH} \
		--build-arg DEPLOYMENT_ENVIRO=${DEPLOYMENT_ENVIRO} \
		--build-arg HTTPS_PROXY=${HTTPS_PROXY} \
		--build-arg HTTP_PROXY=${HTTP_PROXY} \
		--build-arg NO_PROXY=${NO_PROXY} \
		--build-arg MAVEN_SETTINGS_FILE=${MAVEN_SETTINGS_FILE} \
		--build-arg MAVEN_HTTPS_PROXY=${MAVEN_HTTPS_PROXY} \
		-t ${YAMCS_TAG}  .

up: ## Bring up nos3 in detached state (attached state doesn't work for some reason)
	$(MAKE) down || true
	$(MAKE) build-yamcs
	cd ${DOCKER_DIR} && ${CONTAINER_COMPOSE} --env-file ${ENVIRO_FILE} up -d --remove-orphans 

#---
RESET  = \033[0m
PURPLE = \033[0;35m
GREEN  = \033[0;32m
LINE   = $(PURPLE)----------------------------------------------------------------------------------------$(RESET)

help:
	@echo
	@printf "\033[37m%-30s\033[0m %s\n" "#----------------------------------------------------------------------------------------"
	@printf "\033[37m%-30s\033[0m %s\n" "# Makefile targets                                                                       "
	@printf "\033[37m%-30s\033[0m %s\n" "#----------------------------------------------------------------------------------------"
	@echo 
	@printf "\033[37m%-30s\033[0m %s\n" "#-target-----------------------description-----------------------------------------------"
	@grep -E '^[a-zA-Z_-].+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo 

print-%  : ; @echo $* = $($*)
