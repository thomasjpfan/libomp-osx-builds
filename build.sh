#!/bin/bash

set -e


FILE="openmp-11.0.1.src.tar.xz"
FOLDER="openmp-11.0.1.src"
URL="https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/openmp-11.0.1.src.tar.xz"
OUTPUT="libomp-11.0.1.tbz2"


if [ ! -f "$FILE" ]; then
    wget $URL
fi

shasum -c checksum.sha

tar -xf $FILE
git apply --directory $FOLDER arm.patch


mkdir -p opt/local
INSTALL_PREFIX=$PWD/opt/local

pushd $FOLDER
cmake . -DLIBOMP_INSTALL_ALIASES=OFF --install-prefix $INSTALL_PREFIX
make install
cmake . -DLIBOMP_ENABLE_SHARED=OFF -DLIBOMP_INSTALL_ALIASES=OFF --install-prefix $INSTALL_PREFIX
make install
popd

tar -jcvf $OUTPUT opt
