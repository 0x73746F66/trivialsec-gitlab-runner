FROM docker.io/library/amazonlinux:2-with-sources

WORKDIR /srv/app
RUN mkdir -p /var/cache/nginx \
             /usr/share/man/man1mkdir \
             /usr/share/man/man1 && \
    yum update -q -y && \
    yum install -q -y deltarpm wget && \
    yum groupinstall -q -y  "Development Tools" && \
    update-ca-trust force-enable && \
    wget -q http://repo.mysql.com/RPM-GPG-KEY-mysql -O /tmp/mysql.key && \
    rpm --import /tmp/mysql.key && \
    yum install -q -y https://repo.mysql.com/mysql80-community-release-el7-1.noarch.rpm && \
    yum install -q -y https://nmap.org/dist/nmap-7.91-1.x86_64.rpm && \
    amazon-linux-extras enable nginx1 >/dev/null && \
    amazon-linux-extras enable python3.8 >/dev/null && \
    yum install -q -y  \
        nginx \
        hostname \
        python38 \
        python38-pip \
        python38-devel \
        mysql-connector-python \
        PyYAML \
        python3-devel \
        pcre-devel \
        wget \
        curl \
        zip \
        jq \
        shadow-utils \
        procps \
        nano \
        openjdk-11-jdk \
        ldns && \
    setcap 'cap_net_bind_service=+ep' /usr/sbin/nginx && \
    adduser --create-home --user-group ec2-user && \
    yum clean metadata && \
    yum -q -y clean all && \
    chown -R ec2-user: \
        /srv/app \
        /var/log/nginx \
        /var/lib/nginx \
        /var/cache/nginx && \
    python3.8 -m pip install -q --no-cache-dir -U pip && \
    python3.8 -m pip install -q --no-cache-dir -U setuptools wheel awscli

ENTRYPOINT ["/usr/bin/env"]
CMD ["tail", "-f", "/dev/null"]