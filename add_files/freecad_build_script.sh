#!/bin/bash

git config --global --add safe.directory /mnt/source

set -e

# NOTE: The PYTHON_LIBRARY is dependant on the base image used
#   in the docker file.
cmake \
    -D PYTHON_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.10.so.1.0 \
    -D PYTHON_INCLUDE_DIR=/usr/include/python3.10/ \
    -D PYTHON_EXECUTABLE=/usr/bin/python3 \
    -D FREECAD_USE_OCC_VARIANT="Official Version" \
    -D BUILD_QT5=ON \
    -D BUILD_FEM=ON \
    -D BUILD_SANDBOX=OFF \
    -D BUILD_DESIGNER_PLUGIN=ON \
    -S /mnt/source \
    -B /mnt/build

pushd /mnt/build
make -j $(nproc --ignore=1)
