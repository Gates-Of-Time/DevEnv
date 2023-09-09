FROM debian:11-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get install -y wget software-properties-common apt-transport-https lsb-release && \
    apt-get update -y && \
    apt-get install -y python3-mysqldb mariadb-server mariadb-client mariadb-common default-libmysqlclient-dev  build-essential debconf-utils gcc g++ libtool cpp cmake curl git git-core libboost-all-dev liblua5.1-dev libluabind-dev libperl-dev lua5.1 luajit  libdbi-perl libluajit-5.1-dev libmbedtls-dev libio-stringy-perl jq libjson-perl libsodium-dev libssl-dev uuid-dev minizip make locales nano open-vm-tools unzip iputils-ping wget php php-mysqli gdb locate apache2 php libapache2-mod-php php-cli php-mysql php-gd php-tidy php libdbd-mysql-perl && \
    rm -rf /tmp/* && \
    apt-get clean cache

RUN yes '' | perl -MCPAN -e 'install Switch' && perl -MCPAN -e 'install Net::Telnet'

SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/src/run.sh"]
