SHELL := /bin/bash
-include .env
export $(shell sed 's/=.*//' .env)

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
NAME_CI     = registry.gitlab.com/trivialsec/gitlab-runner

ifndef CI_BUILD_REF
	CI_BUILD_REF = local
endif

pull: ## pull latest gitlab-runner image
	docker pull -q $(NAME_CI):latest

build: pull ## build gitlab-runner image
	docker build -q --compress \
		--cache-from $(NAME_CI):latest \
		-t $(NAME_CI):${CI_BUILD_REF} \
		-t $(NAME_CI):latest .

push: ## push built gitlab-runner image
	docker push -q $(NAME_CI):latest

#####################
# Development Only
#####################
setup: ## Creates docker networks and volumes
	docker volume create --name=gitlab-cache 2>/dev/null || true

deploy-key: ## fetches the gitlab-ci deploy key
ifdef AWS_PROFILE
	aws --profile $(AWS_PROFILE) s3 cp --only-show-errors s3://stateful-trivialsec/deploy-keys/gitlab_ci docker/gitlab-runner/gitlab_ci
else
	aws s3 cp --only-show-errors s3://stateful-trivialsec/deploy-keys/gitlab_ci docker/gitlab-runner/gitlab_ci
endif

docker-login: ## login to docker cli using $GITLAB_USER and $GITLAB_PAT
	@echo $(shell [ -z "${GITLAB_PAT}" ] && echo "GITLAB_PAT missing" )
	@echo ${GITLAB_PAT} | docker login -u ${GITLAB_USER} --password-stdin registry.gitlab.com

start: build ## run a local gitlab-runner
	@echo $(shell [ -z "${RUNNER_TOKEN}" ] && echo "RUNNER_TOKEN missing" )
	docker run -d --rm \
		--name gitlab-runner \
		-v "/var/run/docker.sock:/var/run/docker.sock:rw" \
		-e RUNNER_TOKEN=${RUNNER_TOKEN} \
		$(NAME_CI):latest
	docker exec -ti gitlab-runner gitlab-runner register --non-interactive \
		--tag-list 'builder,linode' \
		--name trivialsec-shared \
		--request-concurrency 5 \
		--url https://gitlab.com/ \
		--registration-token '$(RUNNER_TOKEN)' \
		--cache-dir '/cache' \
		--executor shell
