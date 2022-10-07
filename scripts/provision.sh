#!/bin/sh
set -e

source_database()
{
  DATABASE_URL=$1

  rm -rf db
  mkdir -p db

  wget -O db/latest.sql.gz $DATABASE_URL
  wget -O db/peq-editor-schema.sql https://github.com/ProjectEQ/peqphpeditor/raw/master/sql/schema.sql

  gunzip db/latest.sql.gz

  echo "Waiting for database to start up..."
  while ! mysqladmin ping -h"db" --silent; do
    sleep 1
  done

  cd db

  sed 's/\sDEFINER=`[^`]*`@`[^`]*`//g' -i latest.sql

  echo "Sourcing database. This may take a few minutes..."
  mysql --defaults-extra-file=../config/my.cnf eqemu < latest.sql
  mysql --defaults-extra-file=../config/my.cnf eqemu < peq-editor-schema.sql

  cd ..

  rm -rf db

  /home/eqemu/utils/scripts/eqemu_server.pl source_peq_db
  /home/eqemu/utils/scripts/eqemu_server.pl check_db_updates
  /home/eqemu/utils/scripts/eqemu_server.pl fetch_utility_scripts
  /home/eqemu/utils/scripts/eqemu_server.pl opcodes
  /home/eqemu/utils/scripts/eqemu_server.pl plugins
  /home/eqemu/utils/scripts/eqemu_server.pl lua_modules
}

set_to()
{
  ERA=$1

  cp /home/eqemu/config/eqemu.env.example /home/eqemu/config/eqemu.env

  case $ERA in
    classic)
    echo "Configurating environment for Classic."
      sed "/EXPANSION_LIMIT/c EXPANSION_LIMIT=1" /home/eqemu/config/eqemu.env > tmp; cat tmp > /home/eqemu/config/eqemu.env; rm tmp
      ;;
    kunark)
      echo "Configurating environment for Kunark."
      sed "/EXPANSION_LIMIT/c EXPANSION_LIMIT=2" /home/eqemu/config/eqemu.env > tmp; cat tmp > /home/eqemu/config/eqemu.env; rm tmp
      ;;
    latest)
      echo "Configurating environment for Latest."
      sed "/EXPANSION_LIMIT/c EXPANSION_LIMIT=26" /home/eqemu/config/eqemu.env > tmp; cat tmp > /home/eqemu/config/eqemu.env; rm tmp
      ;;
  esac
}

echo "Select which database you would like to install:"
echo ""
echo "1.) FVProject Classic"
echo "2.) FVProject Kunark"
echo "3.) FVProject Latest"
echo "4.) Exit"

read selection

case $selection in
  1)
    source_database http://kunark.fvproject.com/db_dump/latest.sql.gz
    set_to classic
    ;;
  2)
    source_database http://kunark.fvproject.com/db_dump/latest.sql.gz
    set_to kunark
    ;;
  3)
    source_database http://kunark.fvproject.com/db_dump/latest.sql.gz
    set_to latest
    ;;
  4)
    cleanup
    ;;
  *)
    echo "Invalid option selected."
    cleanup
    ;;
esac
