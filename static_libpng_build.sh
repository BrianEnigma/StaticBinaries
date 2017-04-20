#!/bin/bash

# Where to find the things

LIBPNG_URL=http://prdownloads.sourceforge.net/libpng/libpng-1.6.29.tar.gz?download
LIBPNG_FILENAME=libpng-1.6.29.tar.gz

# Download the archive

if [ ! -f "$LIBPNG_FILENAME" ]; then
    wget -O $LIBPNG_FILENAME $LIBPNG_URL
fi

# Extract the archive

if [ ! -f libpng ]; then
    rm -rf libpng
    mkdir libpng
    tar -zxvf $LIBPNG_FILENAME -C libpng --strip-components 1
fi

# Configure

if [ ! -f libpng/Makefile ]; then
    cd libpng
    ./configure --prefix=`pwd` --disable-shared --enable-static
    cd ..
fi

# Build it

if [ ! -f libpng/lib/libpng.a ]; then
    cd libpng
    make
    make install
    mkdir -p lib
    cp ./.libs/* ./lib/
    cd ..
fi

# Print size

echo -n 'File size: '
du -sh libpng/lib/libpng16.a

