## Setup

Clone this repo to your local machine:
```
  git clone git@github.com:Gates-Of-Time/DevEnv.git
```

First copy the `config/eqemu_config.json.example` to `config/eqemu_config.json` and configure it to your settings and make sure you open the following ports(TCP/UDP) on your router to forward to the machine you are running this:
```
  5998
  5999
  7778
  9000
  9001
  9080
  9081
  7000-7100
```

To access PEQEditor go to http://127.0.0.1:8080.

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
