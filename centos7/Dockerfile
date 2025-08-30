FROM centos:7.7.1908

ARG REDIS_VERSION
ENV \
LANG=en_US.utf8 \
REDIS_VERSION=${REDIS_VERSION:-6.2.19}

RUN \
sed -i.bak \
-e 's|^mirrorlist=|#mirrorlist=|g' \
-e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.ustc.edu.cn/centos-vault/centos|g' \
/etc/yum.repos.d/CentOS-Base.repo && \
yum makecache && \
yum install -y coreutils curl gcc make openssl-devel git wget bash systemd-devel

RUN mkdir -p /build
WORKDIR /build
RUN \
curl -fS#L https://github.com/redis/redis/archive/${REDIS_VERSION}/redis-${REDIS_VERSION}.tar.gz | tar xz --strip-components=1; \
make USE_SYSTEMD=yes; \
cd src/; \
ls -l; \
ls -l |grep -v -E ".c$|.h$|.d$|.o$|Makefile|modules|.rb$"; \
./redis-server --version; \
tar -cvzf redis-$(uname -s | tr '[:upper:]' '[:lower:]')-${REDIS_VERSION}-$(arch).tar.gz ./redis-benchmark ./redis-cli ./redis-server; \
tar -tf ./redis-$(uname -s | tr '[:upper:]' '[:lower:]')-${REDIS_VERSION}-$(arch).tar.gz; \
ls -l |grep -v -E ".c$|.h$|.d$|.o$|Makefile|modules|.rb$";