#!/bin/sh
set -e

cleanup()
{
  docker-compose down
}
cntr_c()
{
  cleanup
  exit
}
trap cleanup EXIT
trap cntr_c SIGINT

source_database()
{
  DATABASE_URL=$1

  rm -rf db
  mkdir -p db

  wget -O db/db.zip $DATABASE_URL
  wget -O db/peq-editor-schema.sql https://github.com/ProjectEQ/peqphpeditor/raw/master/sql/schema.sql

  unzip -d db/ -j db/db.zip

  docker-compose up -d db

  echo "Waiting for database to start up..."
  while ! mysqladmin ping -h"127.0.0.1" --silent; do
    sleep 1
  done

  cd db

  echo "Sourcing database. This may take a few minutes..."
  mysql --defaults-extra-file=../config/my.cnf eqemu < create_all_tables.sql
  mysql --defaults-extra-file=../config/my.cnf eqemu < peq-editor-schema.sql

  cd ..

  rm -rf db

  docker-compose run --name provision -d --entrypoint "/bin/bash" shared_memory
  docker-compose exec shared_memory /home/eqemu/utils/scripts/eqemu_server.pl source_peq_db
  docker-compose exec shared_memory /home/eqemu/utils/scripts/eqemu_server.pl check_db_updates
  docker-compose exec shared_memory /home/eqemu/utils/scripts/eqemu_server.pl fetch_utility_scripts
  docker-compose exec shared_memory /home/eqemu/utils/scripts/eqemu_server.pl opcodes
  docker-compose exec shared_memory /home/eqemu/utils/scripts/eqemu_server.pl plugins
  docker-compose exec shared_memory /home/eqemu/utils/scripts/eqemu_server.pl lua_modules

  docker stop provision
  docker rm provision
  docker-compose down
}

echo "Select which database you would like to install:"
echo ""
echo "1.) FVProject Classic"
echo "2.) FVProject Kunark"
echo "3.) PEQ Latest"
echo "4.) Exit"

read selection

case $selection in
  3)
    source_database http://db.projecteq.net/latest
    ;;
  4)
    cleanup
    ;;
  *)
    echo "Invalid option selected."
    cleanup
    ;;
esac
