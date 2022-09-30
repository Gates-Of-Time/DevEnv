## Setup

Clone this repo to your local machine:
```
  git clone git@github.com:whatever/whatever.git
```

First copy the `config/eqemu_config.json.example` to `config/eqemu_config.json` and configure it to your settings

Then run the provision command first. You will be prompted to which database you would like to install:
```
  ./provision.sh
```

Give shared memory a first run to preload everything:
```
  docker-compose run shared_memory
```

Once you have provisioned everything and preran shared_memory, you can start up the services:
```
  docker-compose up
```

## Prerequisites

The following need to be installed on the local machine:
- Docker
- Docker Compose

## How to rebuild docker images
```
cd containers/eqemu-server
docker build -t fvproject/eqemu-server .

cd containers/maps
docker build -t fvproject/maps .

cd containers/peq-editor
docker build -t fvproject/peq-editor .

cd containers/quests
docker build --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)" -t fvproject/quests .
```
