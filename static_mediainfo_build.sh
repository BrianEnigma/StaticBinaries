#!/bin/bash

VERSION=17.12
MEDIAINFO_URL=https://mediaarea.net/download/binary/mediainfo/${VERSION}/MediaInfo_CLI_${VERSION}_GNU_FromSource.tar.bz2
MEDIAINFO_FILE=MediaInfo-${VERSION}.tar.bz2

if [ ! -f $MEDIAINFO_FILE ]; then
    wget -O $MEDIAINFO_FILE "$MEDIAINFO_URL"
fi

if [ ! -f MediaInfo/MediaInfo/Project/GNU/CLI/mediainfo ]; then
    rm -rf MediaInfo
    mkdir MediaInfo
    tar -jxvf $MEDIAINFO_FILE -C MediaInfo --strip-components 1
    cd MediaInfo
    ./CLI_Compile.sh
    cd ..
fi

cp MediaInfo/MediaInfo/Project/GNU/CLI/mediainfo ./bin/
du -sh ./bin/mediainfo

if [ -f /usr/bin/ldd ]; then
	# Linux
	echo ''
	echo 'Dependencies:'
	ldd bin/mediainfo
fi

if [ -f /usr/bin/otool ]; then
	# Mac
	echo ''
	echo 'Dependencies:'
	otool -L bin/mediainfo
fi  

