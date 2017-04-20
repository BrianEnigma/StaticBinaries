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
    ./configure --disable-shared --enable-static
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
du -sh bin/convert

# Print library dependencies

if [ -f /usr/bin/ldd ]; then
    # Linux
    echo ''
    echo 'Dependencies:'
    ldd bin/convert
fi

if [ -f /usr/bin/otool ]; then
    # Mac
    echo ''
    echo 'Dependencies:'
    otool -L bin/convert
fi
