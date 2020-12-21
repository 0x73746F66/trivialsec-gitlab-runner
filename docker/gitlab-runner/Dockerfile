FROM gitlab/gitlab-runner
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        python3.8 \
        python3.8-distutils \
        python3.8-dev \
        unzip \
        zip \
        jq && \
    curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.8 get-pip.py  && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* && \
    python3.8 -m pip install -q --no-cache-dir -U pip setuptools wheel && \
    CFLAGS="-O0" STATICBUILD=true python3.8 -m pip install -q --no-cache-dir -U awscli pylint

VOLUME [ "/etc/gitlab-runner" ]