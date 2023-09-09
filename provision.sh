#!/bin/sh
set -e

cleanup()
{
  docker-compose stop
  docker rm --force  provision
}
cntr_c()
{
  cleanup
  exit
}
trap cleanup EXIT
trap cntr_c SIGINT

cleanup

docker-compose run --name provision --entrypoint "/home/eqemu/provision.sh" shared_memory
docker-compose run shared_memory

git clone git@github.com:Gates-Of-Time/FVProject-Quests.git quests
