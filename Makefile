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
	docker volume create --name=elasticsearch 2>/dev/null || true
	docker volume create --name=mysql-main-data 2>/dev/null || true
	docker volume create --name=mysql-replica-data 2>/dev/null || true
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

buildci-node: ## build nodejs image
	docker pull -q $(NAME_NODE):latest
	docker build -q --compress \
		--cache-from $(NAME_NODE):latest \
		-t $(NAME_NODE):${CI_BUILD_REF} \
		-t $(NAME_NODE):latest \
		--build-arg NODE_ENV=${NODE_ENV} \
        --build-arg NODE_PATH=${NODE_PATH} \
		./docker/node

pushci-node: ## push built nodejs image
	docker push -q $(NAME_NODE):${CI_BUILD_REF}
	docker push -q $(NAME_NODE):latest

buildci-waf: ## build waf image
	docker pull -q $(NAME_WAF):latest
	docker build -q --compress \
		--cache-from $(NAME_WAF):latest \
		-t $(NAME_WAF):${CI_BUILD_REF} \
		-t $(NAME_WAF):latest \
		--build-arg NGINX_VERSION=${NGINX_VERSION} \
        --build-arg GEO_DB_RELEASE=${GEO_DB_RELEASE} \
        --build-arg MODSEC_BRANCH=${MODSEC_BRANCH} \
        --build-arg OWASP_BRANCH=${OWASP_BRANCH} \
		./docker/waf

pushci-waf: ## push built waf image
	docker push -q $(NAME_WAF):${CI_BUILD_REF}
	docker push -q $(NAME_WAF):latest

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

update: ## pulls images
	docker-compose pull

rebuild: down build-ci ## alias for down && build-ci

docker-login: ## login to docker cli using $DOCKER_USER and $DOCKER_PASSWORD
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
	docker-compose exec mysql-main bash -c "mysql -uroot -p'$(MYSQL_MAIN_PASSWORD)' -q -s < /tmp/sql/schema.sql"
	docker-compose exec mysql-main bash -c "mysql -uroot -p'$(MYSQL_MAIN_PASSWORD)' -q -s < /tmp/sql/init-data.sql"

db-rebuild: ## runs drop tables sql script, then applies mysql schema and initial data
	docker-compose up -d mysql-main
	sleep 5
	docker-compose exec mysql-main bash -c "mysql -uroot -p'$(MYSQL_MAIN_PASSWORD)' -q -s < /tmp/sql/drop-tables.sql"
	docker-compose exec mysql-main bash -c "mysql -uroot -p'$(MYSQL_MAIN_PASSWORD)' -q -s < /tmp/sql/schema.sql"
	docker-compose exec mysql-main bash -c "mysql -uroot -p'$(MYSQL_MAIN_PASSWORD)' -q -s < /tmp/sql/init-data.sql"

redis-flush:
	docker-compose exec redis redis-cli FLUSHALL

up: update ## Starts latest container images for: redis, mysql
	docker-compose up -d redis mysql-main mysql-replica elasticsearch

down: ## Bring down containers
	docker-compose down --remove-orphans

build-local-runner: ## build a local gitlab-runner
	docker build -q \
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

es-unknown-sources:
	curl --location --request GET 'http://elastic:${ELASTIC_PASSWORD}@localhost:9200/_search' --header 'Content-Type: application/json' --data-raw '{"query": {"match": {"assigner": "Unknown"}}}' | jq '.hits.hits[]._id'

es-cves:
	curl --location --request GET 'http://elastic:${ELASTIC_PASSWORD}@localhost:9200/cves/_stats' | jq -CS
