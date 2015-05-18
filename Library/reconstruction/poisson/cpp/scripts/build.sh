#!/bin/bash
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${DIR}/..

cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=Release

rm -f *.mexa64
make -j13 -Cbuild

echo "Build successful"
