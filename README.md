# <img src=".repo/assets/icon-512x512.png"  width="52" height="52"> TrivialSec

[![pipeline status](https://gitlab.com/trivialsec/containers-common/badges/main/pipeline.svg)](https://gitlab.com/trivialsec/containers-common/commits/main)

Current tech stack

- docker
- docker-compose
- sysdig
- seccomp
- gnumake / bash
- gitlab ce
- Redis
- MongoDB
- MySQL v8
- M/Monit

## gitlab-runner

Included commands;

- terraform
- semgrep
- python3
- python3 -m pip
- wheel
- pylint
- zip / unzip
- tar
- gzip
- gunzip
- gnupg2
- jq
- aws
- curl

To add a new or update existing dependancy of the runner, just make the changes in `docker/gitlab-runner/Dockerfle` and run:

```bash
docker-compose pull gitlab-runner
docker-compose build --no-cache gitlab-runner
docker-compose up -d --scale gitlab-runner=5 gitlab-runner
```

## Python base image


## Node.js base image

## Mysql main and replica

- Ensure you run `make setup` to create docker volumes
- Start `docker-compose up -d mysql-main` but don't run any create statements yet
- then connect and run `GRANT REPLICATION SLAVE ON *.* TO "root"@"%"; FLUSH PRIVILEGES;`
- then run `SHOW MASTER STATUS` and note the log file and position
- Start `docker-compose up -d mysql-replica`
- then connect and run:
```
STOP SLAVE;
CHANGE MASTER TO GET_MASTER_PUBLIC_KEY=1;
CHANGE MASTER TO MASTER_HOST='mysql-main', MASTER_USER='root', MASTER_PASSWORD='2110Hawa11', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=0;
START SLAVE;
```
- connect to main and run `schema.sql` and `init-data.sql`
- connect to replica and confirm schema and data replicated
