#!/bin/bash

URL=https://sourceforge.net/projects/libjpeg/files/libjpeg/6b/jpegsrc.v6b.tar.gz/download
FILENAME=jpegsrc.v6b.tar.gz

# Download archive, if required.

if [ ! -f $FILENAME ]; then
	wget -O $FILENAME "$URL"
fi

# Extract

if [ ! -f libjpeg ]; then
	rm -rf libjpeg
	mkdir libjpeg
	tar -zxvf $FILENAME -C libjpeg --strip-components 1
fi

# Configure

if [ ! -f libjpeg/Makefile ]; then
    cd libjpeg
    ./configure --prefix=`pwd` --disable-shared --enable-static
    cd ..
fi

# Build it

if [ ! -f libjpeg/lib/libjpeg.a ]; then
    cd libjpeg
    make LIBTOOL=libtool
    mkdir -p bin
    mkdir -p lib
    mkdir -p man/man1
    make install LIBTOOL=libtool
    cp .libs/libjpeg.a ./lib/
    cd ..
fi

# Print file size

du -sh libjpeg/lib/libjpeg.a

