SHELL := /bin/bash
-include .env
export $(shell sed 's/=.*//' .env)

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build:
	docker-compose build --compress

buildnc:
	docker-compose build --no-cache --compress

update:
	docker-compose pull redis mysql

rebuild: down build

docker-clean:
	docker rmi $(docker images -qaf "dangling=true")
	yes | docker system prune
	sudo service docker restart

docker-purge:
	docker rmi $(docker images -qa)
	yes | docker system prune
	sudo service docker stop
	sudo rm -rf /tmp/docker.backup/
	sudo cp -Pfr /var/lib/docker /tmp/docker.backup
	sudo rm -rf /var/lib/docker
	sudo service docker start

db-create:
	docker-compose exec mysql bash -c "mysql -uroot -p'$(MYSQL_ROOT_PASSWORD)' -q -s < /tmp/sql/schema.sql"
	docker-compose exec mysql bash -c "mysql -uroot -p'$(MYSQL_ROOT_PASSWORD)' -q -s < /tmp/sql/init-data.sql"

db-rebuild:
	docker-compose up -d mysql
	sleep 5
	docker-compose exec mysql bash -c "mysql -uroot -p'$(MYSQL_ROOT_PASSWORD)' -q -s < /tmp/sql/drop-tables.sql"
	docker-compose exec mysql bash -c "mysql -uroot -p'$(MYSQL_ROOT_PASSWORD)' -q -s < /tmp/sql/schema.sql"
	docker-compose exec mysql bash -c "mysql -uroot -p'$(MYSQL_ROOT_PASSWORD)' -q -s < /tmp/sql/init-data.sql"

up: update
	docker-compose up -d redis mysql

down:
	docker-compose down
