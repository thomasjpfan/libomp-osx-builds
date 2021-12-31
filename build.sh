#!/bin/bash

set -e


if [ ! -f "openmp-11.1.0.src.tar.xz" ]; then
    wget https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/openmp-11.1.0.src.tar.xz
fi

shasum -c checksum.sha

tar -xf openmp-11.1.0.src.tar.xz
git apply --directory openmp-11.1.0.src arm.patch


mkdir -p opt/local
INSTALL_PREFIX=$PWD/opt/local

pushd openmp-11.1.0.src
cmake . -DLIBOMP_INSTALL_ALIASES=OFF --install-prefix $INSTALL_PREFIX
make install
cmake . -DLIBOMP_ENABLE_SHARED=OFF -DLIBOMP_INSTALL_ALIASES=OFF --install-prefix $INSTALL_PREFIX
make install
popd

tar -jcvf libomp-11.1.0.tbz2 opt
