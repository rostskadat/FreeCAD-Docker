FROM ubuntu:jammy

ENV FREECAD_VERSION="FreeCAD-1-0"

LABEL MAINTAINER="xxxx@example.com"
LABEL DESCRIPTION="A docker image to build FreeCAD locally"
LABEL VERSION="$FREECAD_VERSION"

SHELL ["/bin/bash", "-c"]

WORKDIR /tmp

# REF: https://wiki.freecad.org/Compile_on_Linux

# #!/bin/sh
# sudo add-apt-repository --enable-source ppa:freecad-maintainers/freecad-daily && sudo apt-get update
# sudo apt-get build-dep freecad-daily
# sudo apt-get install freecad-daily

# git clone --recurse-submodules https://github.com/FreeCAD/FreeCAD.git freecad-source
# mkdir freecad-build
# cd freecad-build
# cmake -DPYTHON_EXECUTABLE=/usr/bin/python3 -DFREECAD_USE_PYBIND11=ON ../freecad-source
# make -j$(nproc --ignore=2)

ENV DEBIAN_FRONTEND=noninteractive

# Build tools, and misc supporting tools
RUN apt update && \
    apt install -y build-essential cmake libtool lsb-release git

# Python3
RUN apt install -y python3 swig

# Boost libraries
RUN apt install -y \
    libboost-dev \
    libboost-date-time-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-iostreams-dev \
    libboost-program-options-dev \
    libboost-python-dev \
    libboost-regex-dev \
    libboost-serialization-dev \
    libboost-thread-dev

# Coin libraries
RUN apt install -y libcoin-dev libcoin-doc libcoin-runtime

# Misc libraries
RUN apt install -y \
    libeigen3-dev \
    libgts-bin \
    libgts-dev \
    libkdtree++-dev \
    libmedc-dev \
    libopencv-dev \
    libproj-dev \
    libvtk9-dev \
    libx11-dev \
    libxerces-c-dev \
    libyaml-cpp-dev \
    libzipios++-dev 

# Python 3 and Qt5
RUN apt install -y \
    libpyside2-dev \
    libqt5opengl5-dev \
    libqt5svg5-dev \
    libqt5x11extras5-dev \
    libqt5xmlpatterns5-dev \
    libshiboken2-dev \
    pyqt5-dev-tools \
    pyside2-tools \
    python3-dev \
    python3-matplotlib \
    python3-packaging \
    python3-pivy \
    python3-ply \
    python3-pyside2.qtcore \
    python3-pyside2.qtgui \
    python3-pyside2.qtnetwork \
    python3-pyside2.qtsvg \
    python3-pyside2.qtwebchannel \
    python3-pyside2.qtwebengine \
    python3-pyside2.qtwebenginecore \
    python3-pyside2.qtwebenginewidgets \
    python3-pyside2.qtwidgets \
    qtbase5-dev \
    qttools5-dev \
    qtwebengine5-dev

# OpenCascade
RUN apt install -y libocct*-dev occt-draw

# Optional packges
RUN apt install -y \
    checkinstall \
    doxygen \
    graphviz \
    libsimage-dev \
    libspnav-dev

# To fix compilation problems
RUN apt install -y \
    libhdf5-openmpi-dev \
    python3-pip

# Known python dependencies
RUN python3 -m pip install ifcopenshell==0.8.0 

# Add the build script
ADD add_files/freecad_build_script.sh /root/build_script.sh


WORKDIR /root

# Note for later: May need -fPIC
