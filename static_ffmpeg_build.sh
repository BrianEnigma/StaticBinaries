#!/bin/bash

# Where to find the things

X264_FILENAME=x264
X264_URL=https://code.videolan.org/videolan/x264.git
X264_STABLE_SHA=d198931a63049db1f2c92d96c34904c69fde8117
FFMPEG_FILENAME=ffmpeg-4.3.1.tar.bz2
FFMPEG_URL=http://ffmpeg.org/releases/$FFMPEG_FILENAME

# Download the things

if [ ! -d "$X264_FILENAME" ]; then
    git clone "$X264_URL"
    cd "$X264_FILENAME"
    git checkout "$X264_STABLE_SHA"
    cd ..
fi

if [ ! -f "$FFMPEG_FILENAME" ]; then
    wget $FFMPEG_URL
fi

HERE=`pwd`

# Build x264 static library, if not already built

if [ ! -f x264/libx264.a ]; then
    echo "Configuring x264"
    cd x264
    ./configure --enable-static --disable-asm --prefix=.
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
    echo "Configuring ffmpeg"
    ./configure --disable-shared --enable-static \
        --disable-asm \
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

