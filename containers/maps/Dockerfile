FROM ubuntu:focal AS intermediate

RUN apt update -y && \
    apt-get install -y wget unzip

ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa

RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

ENV MAPS_URL=http://analytics.akkadius.com/maps.zip
ENV MAPS_DIR=/home/eqemu/maps

RUN mkdir -p $MAPS_DIR

RUN wget -O maps.zip $MAPS_URL
RUN unzip maps.zip

RUN mv EQEmuMaps-master $MAPS_DIR

RUN rm maps.zip
