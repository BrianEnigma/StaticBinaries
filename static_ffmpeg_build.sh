#!/bin/bash

# Where to find the things

X264_FILENAME=x264-snapshot-20170317-2245-stable.tar.bz2
X264_URL=ftp://ftp.videolan.org/pub/x264/snapshots/$X264_FILENAME
FFMPEG_FILENAME=ffmpeg-3.4.1.tar.bz2
FFMPEG_URL=http://ffmpeg.org/releases/$FFMPEG_FILENAME

# Download the things

if [ ! -f "$X264_FILENAME" ]; then
    curl -o $X264_FILENAME $X264_URL
fi

if [ ! -f "$FFMPEG_FILENAME" ]; then
    wget $FFMPEG_URL
fi

HERE=`pwd`

# Build x264 static library, if not already built

if [ ! -f x264/libx264.a ]; then
    rm -rf x264
    mkdir x264
    tar -jxvf $X264_FILENAME -C x264 --strip-components 1
    cd x264
    ./configure --enable-static --prefix=.
    make
    make install
    cd ..
fi

# Build ffmpeg static binary, if not already built

if [ ! -f ffmpeg/ffmpeg ]; then
    rm -rf ffmpeg
    mkdir ffmpeg
    tar -jxvf $FFMPEG_FILENAME -C ffmpeg --strip-components 1
    cd ffmpeg
    ./configure --disable-shared --enable-static \
        --enable-gpl --enable-libx264 --enable-pthreads \
        --extra-cflags="-I$HERE/x264/include" \
        --extra-ldflags="-I$HERE/x264/include -L$HERE/x264/lib" \
        --extra-libs=-ldl
    make
    cd ..
fi

# Copy to bin folder

mkdir -p bin
cp ./ffmpeg/ffmpeg ./bin
cp ./ffmpeg/ffprobe ./bin
cp ./ffmpeg/ffserver ./bin

# Print size

echo -n 'File size: '
du -sh bin/ffmpeg

# Print library dependencies

if [ -f /usr/bin/ldd ]; then
    # Linux
    echo ''
    echo 'Dependencies:'
    ldd bin/ffmpeg
fi

if [ -f /usr/bin/otool ]; then
    # Mac
    echo ''
    echo 'Dependencies:'
    otool -L bin/ffmpeg
fi

