FROM docker.io/library/python:3.8-slim
LABEL org.opencontainers.image.authors="Christopher Langton"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.source="https://gitlab.com/trivialsec/containers-common"

ARG PYTHONUTF8
ARG PYTHONUNBUFFERED
ARG LC_ALL
ARG LANG
ARG CFLAGS
ARG STATICBUILD

ENV PYTHONUTF8 ${PYTHONUTF8}
ENV PYTHONUNBUFFERED ${PYTHONUNBUFFERED}
ENV LC_ALL ${LC_ALL}
ENV LANG ${LANG}
ENV CFLAGS ${CFLAGS}
ENV STATICBUILD ${STATICBUILD}}
ENV PATH "${PATH}:/srv/app/.local/bin"
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Preparing folders..." && \
        mkdir -p /var/log/gunicorn \
             /usr/share/man/man1mkdir \
             /usr/share/man/man1 && \
        touch /tmp/application.log && \
        echo "Creating user and group..." && \
        addgroup trivialsec && \
        adduser --disabled-password --gecos '' --disabled-login --home /srv/app --ingroup trivialsec trivialsec && \
        echo "Patching..." && \
        apt-get update -q && \
        apt-get upgrade -qy && \
        echo "Installing Dependencies..." && \
        apt-get install -qy --no-install-recommends \
            build-essential git wget curl bash jq openjdk-11-jdk tar zip \
            ldnsutils logrotate ca-certificates openssl nmap libssl-dev \
            python3-dev default-mysql-client && \
        python3 -m pip install -q --no-cache-dir --no-warn-script-location -U pip && \
        chown -R trivialsec:trivialsec /srv/app /var/log/gunicorn

WORKDIR /srv/app
USER trivialsec
RUN python3 -m pip install -q --no-cache-dir --no-warn-script-location -U setuptools wheel pipx && \
        pipx install awscli && \
        pipx install gunicorn

USER root
RUN echo "Clean up..." && \
        apt-get autoremove -y && \
        apt-get clean && \
        rm -rf /tmp/* /var/lib/apt/lists/*

USER trivialsec
ENTRYPOINT ["/usr/bin/env"]
CMD ["/usr/bin/python3"]
