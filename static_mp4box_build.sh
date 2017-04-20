#!/bin/bash

MP4BOX_URL=https://github.com/gpac/gpac/archive/v0.7.0.tar.gz
MP4BOX_FILE=MP4Box-0.7.0.tgz
HERE=`pwd`

if [ ! -f $MP4BOX_FILE ]; then
    wget -O $MP4BOX_FILE "$MP4BOX_URL"
fi

if [ ! -f MP4Box/bin/gcc/MP4Box ]; then
    rm -rf MP4Box
    mkdir MP4Box
    tar -zxvf $MP4BOX_FILE -C MP4Box --strip-components 1
    cd MP4Box
    ./configure --enable-static-bin
#    ./configure --enable-static-bin \
#        --use-png=$HERE/libpng \
#        --use-ffmpeg=$HERE/ffmpeg \
#        --use-jpeg=$HERE/libjpeg/ \
#        "--extra-cflags=-I$HERE/libpng/include -I$HERE/libjpeg/include -I$HERE/ffmpeg"
    make
    cd ..
fi

cp MP4Box/bin/gcc/MP4Box ./bin/
cp MP4Box/bin/gcc/MP42TS ./bin/
cp MP4Box/bin/gcc/MP4Client ./bin/

du -sh ./bin/MP4Box

if [ -f /usr/bin/ldd ]; then
	# Linux
	echo ''
	echo 'Dependencies:'
	ldd bin/MP4Box
fi

if [ -f /usr/bin/otool ]; then
	# Mac
	echo ''
	echo 'Dependencies:'
	otool -L bin/MP4Box
fi  

