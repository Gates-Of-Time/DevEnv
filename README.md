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

Once you have provisioned everything, you can start up the services:
```
  docker-compose up
```
If you want to use make code edits to the source code and use the dev builds, run the following:
```
  cd containers/eqemu-server
  git clone {{EQEMU_SERVER_REPO_URL}} source
  docker build -t fvproject/eqemu-server-builder -f Dockerfile.builder .
  ./run.sh
  cd /src
  ./build.sh
  docker-compose -f docker-compose.dev.yml up
```

## Prerequisites

The following need to be installed on the local machine:
- Docker
- Docker Compose

## How to rebuild docker images
```
docker compose build
```

OR

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
