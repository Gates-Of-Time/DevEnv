#!/bin/bash
set -e


cd containers/eqemu-server
docker build -t fvproject/eqemu-server .
cd ../..

cd containers/maps
docker build -t fvproject/maps .
cd ../..

cd containers/peq-editor
docker build -t fvproject/peq-editor .
cd ../..

cd containers/quests
docker build --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)" -t fvproject/quests .
cd ../..
