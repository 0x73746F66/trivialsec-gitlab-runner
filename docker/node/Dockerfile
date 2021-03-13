FROM docker.io/library/amazonlinux:2-with-sources
ARG NODE_ENV
ENV NODE_ENV $NODE_ENV
ARG NODE_PATH
ENV NODE_PATH $NODE_PATH
ENV PATH="$PATH:$NODE_PATH/.bin"

WORKDIR /srv/app
RUN mkdir -p /usr/share/man/man1mkdir /usr/share/man/man1
RUN yum update -q -y && \
    yum install -q -y deltarpm && \
    yum groupinstall -q -y  "Development Tools" && \
    update-ca-trust force-enable && \
    curl -sL https://rpm.nodesource.com/setup_14.x | bash - && \
    curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo && \
    yum install -q -y  \
        hostname \
        zip \
        jq \
        wget \
        nodejs \
        yarn \
        jq \
        shadow-utils \
        procps \
        nano && \
    adduser --create-home --user-group ec2-user && \
    yum clean metadata && \
    yum -q -y clean all

COPY .yarnrc .yarnrc

USER ec2-user
ENTRYPOINT ["/usr/bin/env"]
CMD ["nodemon", "start"]
