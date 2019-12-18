#!/bin/bash

if [ ! -d build ]; then
mkdir build
fi

cd build

if [[ "$OSTYPE" =~ "darwin" ]]; then
  export CXX=/usr/local/opt/llvm/bin/clang++
  export LIBRARY_PATH=/usr/local/opt/llvm/lib:/usr/local/lib
else
  export CXX=/usr/bin/clang++-6.0
fi

cmake ..
make -j2

mkdir -p ~/dev/look/releases/bin
cp PoissonReconApp ~/dev/look/releases/bin/
