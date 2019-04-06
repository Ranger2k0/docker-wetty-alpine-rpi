FROM arm32v7/alpine
MAINTAINER Sven Fischer <sven@leiderfischer.de>

WORKDIR /src

RUN apk add --update nodejs nodejs-npm
RUN apk add --no-cache --virtual .build-deps \
  git python make g++ \
  && apk add --no-cache openssh-client
RUN git clone https://github.com/krishnasrinivas/wetty --branch v1.1.4 /src
# Install typescript on its own because it fails to install when run from a RPi
RUN npm install --global "typescript@~3.1.1"
RUN npm install
RUN apk del .build-deps \
  && adduser -h /src -D term \
  && npm run-script build

ADD run.sh /src

# Default ENV params used by wetty
ENV REMOTE_SSH_SERVER 127.0.0.1
ENV REMOTE_SSH_PORT 22

EXPOSE 3000

ENTRYPOINT "./run.sh"
