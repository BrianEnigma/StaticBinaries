#!/bin/bash

# Build tool prerequisites

sudo yum -y groupinstall "Development Tools"
sudo yum -y install yasm zlib-devel

# Static libraries

./static_libpng_build.sh
./static_libjpeg_build.sh

# Static applications

#TODO

