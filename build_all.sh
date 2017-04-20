#!/bin/bash

# Build tool prerequisites

sudo yum -y groupinstall "Development Tools"
sudo yum -y install yasm zlib-devel

# Static libraries

./static_libpng_build.sh
./static_libjpeg_build.sh

# Static applications

./static_imagemagick_build.sh
./static_sox_build.sh
./static_mediainfo_build.sh
./static_mp4box_build.sh
./static_ffmpeg_build.sh

