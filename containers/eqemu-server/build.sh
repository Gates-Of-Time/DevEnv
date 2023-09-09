#!/bin/bash

docker run \
  --cpus="${CPUS:-4}" \
  --memory="${MEMORY:-16g}" \
  -it \
  --name eqemu-server-builder  \
  --rm  \
  -v ${PWD}:/src \
  fvproject/eqemu-server-builder
