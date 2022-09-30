FROM ubuntu:focal AS intermediate

RUN apt update -y && \
    apt-get install -y git

ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh

RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

ENV QUESTS_URL=git@github.com:Gates-Of-Time/FVProject-Quests.git
ENV QUESTS_DIR=/home/eqemu/quests

RUN git clone $QUESTS_URL $QUESTS_DIR

FROM ubuntu:focal

COPY --from=intermediate $QUESTS_DIR $QUESTS_DIR
