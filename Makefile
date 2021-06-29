SHELL := /bin/bash
-include .env
export $(shell sed 's/=.*//' .env)
.ONESHELL:
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
NAME_PY 	= registry.gitlab.com/trivialsec/containers-common/python
NAME_NODE 	= registry.gitlab.com/trivialsec/containers-common/nodejs
NAME_WAF    = registry.gitlab.com/trivialsec/containers-common/waf
NAME_CI     = registry.gitlab.com/trivialsec/containers-common/gitlab-runner

setup: ## Creates docker networks and volumes
	docker network create trivialsec 2>/dev/null || true
	docker volume create --name=redis-datadir 2>/dev/null || true
	docker volume create --name=mysql-datadir 2>/dev/null || true
	docker volume create --name=gitlab-cache 2>/dev/null || true

build: setup ## docker-compose build
	docker-compose build --compress python nodejs waf gitlab-runner

buildnc: setup ## docker-compose build --no-cache
	docker-compose build --no-cache python nodejs waf gitlab-runner

buildci-py:
	docker pull $(NAME_PY):latest
	docker build --compress \
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

pushci-py:
	docker push $(NAME_PY):${CI_BUILD_REF}
	docker push $(NAME_PY):latest

buildci-node:
	docker pull $(NAME_NODE):latest
	docker build --compress \
		--cache-from $(NAME_NODE):latest \
		-t $(NAME_NODE):${CI_BUILD_REF} \
		-t $(NAME_NODE):latest \
		--build-arg NODE_ENV=${NODE_ENV} \
        --build-arg NODE_PATH=${NODE_PATH} \
		./docker/node

pushci-node:
	docker push $(NAME_NODE):${CI_BUILD_REF}
	docker push $(NAME_NODE):latest

buildci-waf:
	docker pull $(NAME_WAF):latest
	docker build --compress \
		--cache-from $(NAME_WAF):latest \
		-t $(NAME_WAF):${CI_BUILD_REF} \
		-t $(NAME_WAF):latest \
		--build-arg NGINX_VERSION=${NGINX_VERSION} \
        --build-arg GEO_DB_RELEASE=${GEO_DB_RELEASE} \
        --build-arg MODSEC_BRANCH=${MODSEC_BRANCH} \
        --build-arg OWASP_BRANCH=${OWASP_BRANCH} \
		./docker/waf

pushci-waf:
	docker push $(NAME_WAF):${CI_BUILD_REF}
	docker push $(NAME_WAF):latest

buildci-runner:
	docker pull $(NAME_CI):latest
	docker build --compress \
		--cache-from $(NAME_CI):latest \
		-t $(NAME_CI):${CI_BUILD_REF} \
		-t $(NAME_CI):latest \
		--build-arg RUNNER_TOKEN=${RUNNER_TOKEN} \
		./docker/gitlab-runner

pushci-runner:
	docker push $(NAME_CI):${CI_BUILD_REF}
	docker push $(NAME_CI):latest

buildci: buildci-py buildci-node buildci-waf buildci-runner
pushci: pushci-py pushci-node pushci-waf pushci-runner

update: ## pulls images for: redis, mysql
	docker-compose pull redis mysql

rebuild: down build ## alias for down && build

push:
	docker-compose push nodejs python waf gitlab-runner

docker-login:
	@echo $(shell [ -z "${DOCKER_PASSWORD}" ] && echo "DOCKER_PASSWORD missing" )
	@echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USER} --password-stdin registry.gitlab.com

docker-clean: ## quick docker environment cleanup
	docker rmi $(docker images -qaf "dangling=true")
	yes | docker system prune
	sudo service docker restart

docker-purge: ## thorough docker environment cleanup
	docker rmi $(docker images -qa)
	yes | docker system prune
	sudo service docker stop
	sudo rm -rf /tmp/docker.backup/
	sudo cp -Pfr /var/lib/docker /tmp/docker.backup
	sudo rm -rf /var/lib/docker
	sudo service docker start

db-create: ## applies mysql schema and initial data
	docker-compose exec mysql bash -c "mysql -uroot -p'$(MYSQL_ROOT_PASSWORD)' -q -s < /tmp/sql/schema.sql"
	docker-compose exec mysql bash -c "mysql -uroot -p'$(MYSQL_ROOT_PASSWORD)' -q -s < /tmp/sql/init-data.sql"

db-rebuild: ## runs drop tables sql script, then applies mysql schema and initial data
	docker-compose up -d mysql
	sleep 5
	docker-compose exec mysql bash -c "mysql -uroot -p'$(MYSQL_ROOT_PASSWORD)' -q -s < /tmp/sql/drop-tables.sql"
	docker-compose exec mysql bash -c "mysql -uroot -p'$(MYSQL_ROOT_PASSWORD)' -q -s < /tmp/sql/schema.sql"
	docker-compose exec mysql bash -c "mysql -uroot -p'$(MYSQL_ROOT_PASSWORD)' -q -s < /tmp/sql/init-data.sql"

up: update ## Starts latest container images for: redis, mysql
	docker-compose up -d redis mysql

down: ## Bring down containers
	docker-compose down --remove-orphans

build-local-runner:
	docker build \
		--cache-from $(NAME_CI):latest \
		-t $(NAME_CI):local \
		./docker/gitlab-runner

run-local-runner: build-local-runner
	@echo $(shell [ -z "${RUNNER_TOKEN}" ] && echo "RUNNER_TOKEN missing" )
	docker run -d --rm \
		--name gitlab-runner \
		-v "/var/run/docker.sock:/var/run/docker.sock:rw" \
		-e RUNNER_TOKEN=${RUNNER_TOKEN} \
		$(NAME_CI):local
