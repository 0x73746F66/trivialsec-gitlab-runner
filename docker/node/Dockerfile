FROM amazonlinux:2-with-sources
ARG NODE_ENV
ENV NODE_ENV $NODE_ENV
ARG NODE_PATH
ENV NODE_PATH $NODE_PATH
ENV PATH="$PATH:$NODE_PATH/.bin"

WORKDIR /srv/app
RUN mkdir -p /usr/share/man/man1mkdir /usr/share/man/man1 && \
    yum update -q -y && \
    yum install -q -y deltarpm && \
    yum groupinstall -q -y  "Development Tools" && \
    update-ca-trust force-enable && \
    curl -sL https://rpm.nodesource.com/setup_14.x | bash - && \
    curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo && \
    amazon-linux-extras enable epel && \
    yum install -q -y  \
        hostname \
        zip \
        jq \
        epel-release \
        wget \
        nodejs \
        yarn \
        jq \
        # dev only
        shadow-utils \
        procps \
        nano && \
    adduser --create-home --user-group ec2-user && \
    yum clean metadata && \
    yum -q -y clean all

COPY install-google-chrome.sh install-google-chrome.sh
RUN bash install-google-chrome.sh

COPY .yarnrc .yarnrc

USER ec2-user
ENTRYPOINT ["/usr/bin/env"]
CMD ["nodemon", "start"]
