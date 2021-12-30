# <img src=".repo/assets/icon-512x512.png"  width="52" height="52"> TrivialSec

[![pipeline status](https://gitlab.com/trivialsec/gitlab-runner/badges/main/pipeline.svg)](https://gitlab.com/trivialsec/gitlab-runner/commits/main)

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
docker-compose pull registry.gitlab.com/trivialsec/gitlab-runner
docker-compose build --no-cache gitlab-runner
docker-compose up -d --scale gitlab-runner=5 gitlab-runner
```
