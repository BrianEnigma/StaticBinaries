#!/bin/bash

URL=https://sourceforge.net/projects/sox/files/sox/14.4.2/sox-14.4.2.tar.bz2/download
FILENAME=sox-14.4.2.tar.bz2

# Download archive, if required.

if [ ! -f $FILENAME ]; then
	wget -O $FILENAME "$URL"
fi

# Build, if required

if [ ! -f sox/sox ]; then
	rm -rf sox
	mkdir sox
	tar -jxvf $FILENAME -C sox --strip-components 1
	cd sox
	./configure --disable-shared --enable-static
	make
	cp src/sox .
	cd ..
fi

# Copy to bin folder
mkdir -p bin
cp ./sox/sox ./bin

# Print file size

du -sh bin/sox

# Print dependencies

if [ -f /usr/bin/ldd ]; then
	# Linux
	echo ''
	echo 'Dependencies:'
	ldd bin/sox
fi

if [ -f /usr/bin/otool ]; then
	# Mac
	echo ''
	echo 'Dependencies:'
	otool -L bin/sox
fi

