#!/bin/bash

GIT_REPO=https://github.com/ImageMagick/ImageMagick.git
GIT_TAG=7.0.5-4

# Clone the repo

if [ ! -f ImageMagick ]; then
    git clone $GIT_REPO
fi

# Check out the right version and configure

if [ ! -f ImageMagick/Makefile ]; then
    cd ImageMagick
    git checkout $GIT_TAG
    ./configure --disable-shared --enable-static --enable-delegate-build \
        CPPFLAGS="-I`pwd`/../libpng/include -I`pwd`/../libjpeg/include" \
        CFLAGS="-I`pwd`/../libpng/include -I`pwd`/../libjpeg/include" \
        LDFLAGS="-L`pwd`/../libpng/lib -L`pwd`/../libjpeg/lib" \
        PKG_CONFIG_PATH=/home/ec2-user/StaticBinaries/ImageMagick/../libpng
fi

# Build it

if [ ! -f ImageMagick/utilities/convert ]; then
    make
    cd ..
fi

# Copy to bin folder

mkdir -p bin
find ImageMagick/utilities -type f -executable -exec cp \{\} ../bin/ \;

# Print size

echo -n 'File size: '
du -sh bin/magick

# Print library dependencies

if [ -f /usr/bin/ldd ]; then
    # Linux
    echo ''
    echo 'Dependencies:'
    ldd bin/magick
fi

if [ -f /usr/bin/otool ]; then
    # Mac
    echo ''
    echo 'Dependencies:'
    otool -L bin/magick
fi

