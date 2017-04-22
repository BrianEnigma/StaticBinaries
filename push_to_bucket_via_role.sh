#!/bin/bash

BINS="ffmpeg ffprobe ffserver sox magick mediainfo MP4Box MP42TS MP4Client"

if [ -z "$2" ]; then
    echo "USAGE: ./push_to_bucket.sh {bucket} {region}"
    echo "EXAMPLE: ./push_to_bucket.sh mybucket us-west-2"
    echo "It is assumed that this EC2 instance has role-based"
    echo "permissions to write to the bucket."
    exit 1
fi

for f in $BINS; do
    if [ ! -f bin/$f ]; then
        echo "Error: missing expected binary ./bin/$f"
        exit 1
    fi
done

for f in ./bin/*; do
    aws --region "$2" s3 cp $f s3://$1
done

if [ -f output.txt ]; then
    aws --region "$2" s3 cp output.txt s3://$1/output.txt
fi

