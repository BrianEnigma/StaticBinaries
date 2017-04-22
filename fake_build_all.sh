#!/bin/bash

# This script pretends to build all of the binaries. It takes a little bit
# of fake time, but much less time than actually building those binaries.


BINS="ffmpeg ffprobe ffserver sox magick mediainfo MP4Box MP42TS MP4Client"

for f in $BINS; do
    echo "Fake-creating: bin/$f"
    mkdir -p bin
    touch bin/$f
    sleep 5
done

echo "Done.

