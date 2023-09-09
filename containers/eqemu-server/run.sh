#!/bin/bash

cd /src/source
git submodule init && git submodule update

mkdir -p /src/source/build
cd /src/source/build
cmake -DCMAKE_BUILD_TYPE=Debug -DEQEMU_BUILD_LUA=ON -DLUA_INCLUDE_DIR=/usr/include/lua-5.1/ -G "Unix Makefiles" ..
cd ..
PROCS=`nproc --all`
echo "Using $PROCS cpus..."
make -j $PROCS LDFLAGS="-all-static"
