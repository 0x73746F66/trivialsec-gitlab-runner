FROM docker.io/gitlab/gitlab-runner
ARG GO_VERSION=1.16.5
ENV RUNNER_TOKEN=${RUNNER_TOKEN}
ENV DEBIAN_FRONTEND=noninteractive
ENV CFLAGS="-O0"
ENV STATICBUILD=true
ENV PATH=$PATH:/usr/local/go/bin

COPY config.toml /etc/gitlab-runner/config.toml
COPY entrypoint /entrypoint
RUN chmod a+x /entrypoint \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        acl \
        build-essential \
        python3 \
        python3-distutils \
        python3-dev \
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
    && wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && go version \
    && go get -u gitlab.com/gitlab-org/release-cli/... \
    && apt-get update \
    && apt-get install -y \
        terraform \
        docker-ce-cli \
    && curl -s https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py \
    && python3 /tmp/get-pip.py \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/* \
    && terraform -install-autocomplete \
    && python3 -m pip install -q --no-cache-dir -U pip setuptools wheel build twine awscli pylint semgrep

VOLUME [ "/etc/gitlab-runner" ]
