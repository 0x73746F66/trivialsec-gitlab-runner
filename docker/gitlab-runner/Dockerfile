FROM docker.io/gitlab/gitlab-runner

ENV DEBIAN_FRONTEND=noninteractive
ENV CFLAGS="-O0"
ENV STATICBUILD=true

COPY config.toml /etc/gitlab-runner/config.toml
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        python3.8 \
        python3.8-distutils \
        python3.8-dev \
        python3-venv \
        unzip \
        gzip \
        tar \
        jq \
        software-properties-common \
        ca-certificates \
        apt-transport-https \
        lsb-release \
        gnupg \
        gnupg2 \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com focal main" \
    && apt-get update \
    && apt-get install -y \
        terraform \
        docker-ce-cli \
    && setfacl --modify user:999:rw /var/run/docker.sock \
    && curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3 get-pip.py \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/* \
    && terraform -install-autocomplete \
    && python3 -m pip install -q --no-cache-dir -U pip setuptools wheel awscli pylint semgrep

USER root
VOLUME [ "/etc/gitlab-runner" ]
