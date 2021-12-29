SHELL := /bin/bash
-include .env
export $(shell sed 's/=.*//' .env)
.ONESHELL:
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
NAME_CI     = registry.gitlab.com/trivialsec/containers-common/gitlab-runner

ifndef CI_BUILD_REF
	CI_BUILD_REF = local
endif

setup: ## Creates docker networks and volumes
	docker network create trivialsec 2>/dev/null || true
	docker volume create --name=gitlab-cache 2>/dev/null || true

buildci-py: ## build python image
	docker pull -q $(NAME_PY):latest
	docker build -q --compress \
		--cache-from $(NAME_PY):latest \
		-t $(NAME_PY):${CI_BUILD_REF} \
		-t $(NAME_PY):latest \
		--build-arg PYTHONUNBUFFERED=1 \
        --build-arg PYTHONUTF8=1 \
        --build-arg CFLAGS='-O0' \
        --build-arg STATICBUILD=1 \
        --build-arg LC_ALL=C.UTF-8 \
        --build-arg LANG=C.UTF-8 \
		./docker/python

pushci-py: ## push built python image
	docker push -q $(NAME_PY):${CI_BUILD_REF}
	docker push -q $(NAME_PY):latest

deploy-key: ## fetches the gitlab-ci deploy key
ifdef AWS_PROFILE
	aws --profile $(AWS_PROFILE) s3 cp --only-show-errors s3://stateful-trivialsec/deploy-keys/gitlab_ci docker/gitlab-runner/gitlab_ci
else
	aws s3 cp --only-show-errors s3://stateful-trivialsec/deploy-keys/gitlab_ci docker/gitlab-runner/gitlab_ci
endif

buildci-runner: ## build gitlab-runner image
	docker pull -q $(NAME_CI):latest
	docker build -q --compress \
		--cache-from $(NAME_CI):latest \
		-t $(NAME_CI):${CI_BUILD_REF} \
		-t $(NAME_CI):latest \
		--build-arg RUNNER_TOKEN=${RUNNER_TOKEN} \
		./docker/gitlab-runner

pushci-runner: ## push built gitlab-runner image
	docker push -q $(NAME_CI):${CI_BUILD_REF}
	docker push -q $(NAME_CI):latest

build-ci: buildci-py buildci-node buildci-waf buildci-runner ## build docker images
push-ci: pushci-py pushci-node pushci-waf pushci-runner ## push built images

docker-login: ## login to docker cli using $GITLAB_USER and $GITLAB_PAT
	@echo $(shell [ -z "${GITLAB_PAT}" ] && echo "GITLAB_PAT missing" )
	@echo ${GITLAB_PAT} | docker login -u ${GITLAB_USER} --password-stdin registry.gitlab.com

build-local-runner: ## build a local gitlab-runner
	docker build \
		--cache-from $(NAME_CI):latest \
		-t $(NAME_CI):local \
		./docker/gitlab-runner

run-local-runner: build-local-runner ## run a local gitlab-runner
	@echo $(shell [ -z "${RUNNER_TOKEN}" ] && echo "RUNNER_TOKEN missing" )
	docker run -d --rm \
		--name gitlab-runner \
		-v "/var/run/docker.sock:/var/run/docker.sock:rw" \
		-e RUNNER_TOKEN=${RUNNER_TOKEN} \
		$(NAME_CI):local
	docker exec -ti gitlab-runner gitlab-runner register --non-interactive \
		--tag-list 'builder,linode' \
		--name trivialsec-shared \
		--request-concurrency 5 \
		--url https://gitlab.com/ \
		--registration-token '$(RUNNER_TOKEN)' \
		--cache-dir '/cache' \
		--executor shell
