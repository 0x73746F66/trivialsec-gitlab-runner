FROM python:3.8-slim-buster as build
ENV DEBIAN_FRONTEND=noninteractive
ARG MONIT_VERSION
ENV PATH=$PATH:/opt/monit/bin

WORKDIR /opt/src
RUN mkdir -p /opt/src /opt/monit && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        zlib1g-dev \
        libssl-dev \
        wget \
        unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* && \
    echo " ---> https://mmonit.com/monit/dist/monit-${MONIT_VERSION}.tar.gz" && \ 
    wget --no-check-certificate -qO- https://mmonit.com/monit/dist/monit-${MONIT_VERSION}.tar.gz | tar xz && \
    cd /opt/src/monit-${MONIT_VERSION} && \
    ./configure --prefix=/opt/monit --without-pam && \
    make && make install

FROM python:3.8-slim-buster
ENV PATH=$PATH:/opt/monit/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        wget \
        unzip \
        ldnsutils \
        logrotate && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* && \
    adduser --gecos '' --disabled-login --home '/srv/app' trivialsec

WORKDIR /srv/app
COPY --from=build /opt/monit /opt/monit
COPY monitrc monitrc

RUN chmod 0600 monitrc && \
    chown -R trivialsec: monitrc /opt/monit && \
    pip install -q --no-cache-dir --isolated -U pip setuptools wheel

ENTRYPOINT ["/usr/bin/env"]
CMD ["monit", "-I", "-B", "-c", "monitrc"]
