FROM alpine:3.22.1
ARG REDIS_VERSION
ENV \
LANG=en_US.utf8 \
REDIS_VERSION=${REDIS_VERSION:-6.2.19}

RUN \
apk add --no-cache coreutils curl gcc make musl-dev openssl-dev git wget bash

RUN mkdir -p /build
WORKDIR /build
RUN \
curl -fS#L https://github.com/redis/redis/archive/${REDIS_VERSION}/redis-${REDIS_VERSION}.tar.gz | tar xz --strip-components=1; \
make CFLAGS="-static" LDFLAGS="-static"; \
cd src/; \
ls -l; \
ls -l |grep -v -E ".c$|.h$|.d$|.o$|Makefile|modules|.rb$"; \
./redis-server --version; \
tar -cvzf redis-$(uname -s | tr '[:upper:]' '[:lower:]')-${REDIS_VERSION}-$(arch).tar.gz ./redis-benchmark ./redis-cli ./redis-server; \
tar -tf ./redis-$(uname -s | tr '[:upper:]' '[:lower:]')-${REDIS_VERSION}-$(arch).tar.gz; \
ls -l |grep -v -E ".c$|.h$|.d$|.o$|Makefile|modules|.rb$";


