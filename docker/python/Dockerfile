FROM amazonlinux:2-with-sources

WORKDIR /srv/app
RUN mkdir -p /usr/share/man/man1mkdir /usr/share/man/man1 && \
    yum update -q -y && \
    yum install -q -y  deltarpm wget && \
    yum groupinstall -q -y  "Development Tools" && \
    update-ca-trust force-enable && \
    wget -q http://repo.mysql.com/RPM-GPG-KEY-mysql -O /tmp/mysql.key && \
    rpm --import /tmp/mysql.key && \
    yum install -q -y https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm && \
    amazon-linux-extras enable python3.8 >/dev/null && \
    yum install -q -y  \
        hostname \
        python38 \
        python38-pip \
        python38-devel \
        mysql-connector-python \
        PyYAML \
        # build deps
        python3-devel \
        pcre-devel \
        wget \
        curl \
        zip \
        jq \
        # dev only
        shadow-utils \
        procps \
        nano && \
    adduser --create-home --user-group ec2-user && \
    yum clean metadata && \
    yum -q -y clean all && \
    python3.8 -m pip install -q --no-cache-dir -U pip && \
    python3.8 -m pip install -q --no-cache-dir -U setuptools wheel awscli

ENTRYPOINT ["/usr/bin/env"]
CMD ["tail", "-f", "/dev/null"]