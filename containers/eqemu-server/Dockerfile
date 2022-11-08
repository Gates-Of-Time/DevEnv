FROM ubuntu:focal

ARG eqemu_release_tag=latest
ENV EQEMU_RELEASE_TAG=c8b3ca53fe083c1b869625bbae1b5f9b13b75f02

ENV EQEMU_HOME=/home/eqemu
ENV EQEMU_BUILD_DIR=/home/eqemu/build
ENV EQEMU_SRC_DIR=/home/eqemu/source
ENV SERVER_URL=https://github.com/EQEmu/Server.git

ENV DEBIAN_FRONTEND=noninteractive

# Install build prereqs
RUN apt-get update -y && \
    apt-get install -y wget software-properties-common apt-transport-https lsb-release && \
    apt-get update -y && \
    apt-get install -y python3-mysqldb mariadb-server mariadb-client mariadb-common libmysqlclient-dev build-essential debconf-utils gcc g++ libtool cpp cmake curl git git-core libboost-all-dev liblua5.1-dev libluabind-dev libperl-dev libperl5i-perl lua5.1 luajit libluajit-5.1-dev libmbedtls-dev libio-stringy-perl zlibc libjson-perl libsodium-dev libssl-dev uuid-dev minizip make locales nano open-vm-tools unzip iputils-ping wget gdb locate

# Set eqemu user
RUN groupadd eqemu && \
    useradd -g eqemu -d $EQEMU_HOME eqemu && \
    mkdir -p $EQEMU_HOME && \
    mkdir -p $EQEMU_BUILD_DIR

# Copy eqemu sources
RUN git clone $SERVER_URL $EQEMU_SRC_DIR && \
    cd $EQEMU_SRC_DIR && \
    git checkout $EQEMU_RELEASE_TAG && \
    git submodule init && \
    git submodule update

# Compile eqemu
RUN cd $EQEMU_BUILD_DIR && \
    cmake $EQEMU_SRC_DIR && \
    make -j `grep -P '^core id\t' /proc/cpuinfo | sort -u | wc -l` LDFLAGS="-all-static" && \
    make install

# Move files into fresh container to ditch all the cruft:
FROM ubuntu:focal

USER root

ENV EQEMU_HOME=/home/eqemu
ENV EQEMU_BUILD_DIR=/home/eqemu/build
ENV EQEMU_SRC_DIR=/home/eqemu/src

ENV DEBIAN_FRONTEND=noninteractive

# Install minimal packages
RUN apt-get update -y && \
    apt-get install -y wget software-properties-common apt-transport-https lsb-release && \
    apt-get update -y && \
    apt-get install -y python3-mysqldb mariadb-server mariadb-client mariadb-common libmysqlclient-dev build-essential debconf-utils gcc g++ libtool cpp cmake curl git git-core libboost-all-dev liblua5.1-dev libluabind-dev libperl-dev libperl5i-perl lua5.1 luajit libluajit-5.1-dev libmbedtls-dev libio-stringy-perl zlibc libjson-perl libsodium-dev libssl-dev uuid-dev minizip make locales nano open-vm-tools unzip iputils-ping wget php php-mysqli gdb locate apache2 php libapache2-mod-php php-cli php-mysql php-gd php-tidy php && \
    rm -rf /tmp/* && \
    apt-get clean cache

# Set eqemu user
RUN groupadd eqemu && \
    useradd -g eqemu -d $EQEMU_HOME eqemu && \
    mkdir -p $EQEMU_HOME && \
    mkdir -p $EQEMU_BUILD_DIR

COPY --from=0 /usr/local /usr/local
COPY --from=0 /home/eqemu/source/loginserver/login_util/* /home/eqemu/
COPY --from=0 /home/eqemu/source/utils/defaults/log.ini /home/eqemu
COPY --from=0 /home/eqemu/source/utils/defaults/mime.types /home/eqemu
COPY --from=0 /home/eqemu/source/utils/patches/* /home/eqemu/
COPY --from=0 /home/eqemu/source/utils /home/eqemu/utils

RUN mkdir -p /home/eqemu/status
RUN mkdir -p /home/eqemu/shared
RUN mkdir -p /home/eqemu/logs
RUN mkdir -p /home/eqemu/plugins
RUN mkdir -p /home/eqemu/quests
RUN mkdir -p /home/eqemu/maps

RUN ln -s /usr/local/bin /home/eqemu/bin && \
    chown -R eqemu:eqemu /home/eqemu

WORKDIR /home/eqemu

USER eqemu

ENTRYPOINT /bin/bash
