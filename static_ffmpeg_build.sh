#!/bin/bash

# Where to find the things

X264_FILENAME=x264
X264_URL=https://code.videolan.org/videolan/x264.git
X264_STABLE_SHA=31e19f92f00c7003fa115047ce50978bc98c3a0d
X265_FILENAME=x265
X265_URL=https://github.com/videolan/x265.git
X265_STABLE_SHA=02d2f496c94c0ef253766b826d95af3404b2781e
FFMPEG_FILENAME=ffmpeg-6.1.tar.bz2
FFMPEG_URL=http://ffmpeg.org/releases/$FFMPEG_FILENAME

# Download the things

if [ ! -d "$X264_FILENAME" ]; then
    git clone "$X264_URL"
    cd "$X264_FILENAME"
    git checkout "$X264_STABLE_SHA"
    cd ..
fi

if [ ! -d "$X265_FILENAME" ]; then
    git clone "$X265_URL"
    cd "$X265_FILENAME"
    git checkout "$X265_STABLE_SHA"
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

# Build x265 static library, if not already built

if [ ! -f x265/source/libx265.a ]; then
    echo "Building x265"
    cd x265/source
    cmake -DENABLE_SHARED=OFF -DCMAKE_INSTALL_PREFIX=$HERE/x265/usr
    make x265-static install
    cd ../..
fi

# Build ffmpeg static binary, if not already built

if [ ! -f ffmpeg/ffmpeg ]; then
    rm -rf ffmpeg
    mkdir ffmpeg
    tar -jxvf $FFMPEG_FILENAME -C ffmpeg --strip-components 1
    cd ffmpeg
    echo "Configuring ffmpeg"
    PKG_CONFIG_PATH=$HERE/x264:$HERE/x265/usr/lib/pkgconfig ./configure --disable-shared --enable-static \
        --pkg-config-flags="--static" \
        --disable-asm \
        --enable-gpl --enable-libx264 --enable-libx265 --enable-pthreads \
        --extra-cflags="-I$HERE/x264/include -I$HERE/x265/usr/include" \
        --extra-ldflags="-I$HERE/x264/include -I$HERE/x265/usr/include -L$HERE/x264/lib -L$HERE/x265/usr/lib" \
        --extra-libs="-ldl -lpthread"
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

