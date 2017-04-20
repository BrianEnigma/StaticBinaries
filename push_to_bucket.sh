#!/bin/bash

BINS="ffmpeg ffprobe ffserver sox magick"

if [ -z "$3" ]; then
    echo "USAGE: ./push_to_bucket.sh {access key id} {secret} {bucket} {region}"
    echo "EXAMPLE: ./push_to_bucket.sh AKIAIOSFODNN7EXAMPLE wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY mybucket us-west-2"
    exit 1
fi

for f in $BINS; do
    if [ ! -f bin/$f ]; then
        echo "Error: missing expected binary ./bin/$f"
        exit 1
    fi
done

for f in ./bin/*; do
    AWS_ACCESS_KEY_ID="$1" AWS_SECRET_ACCESS_KEY="$2" aws --region "$4" s3 cp $f s3://$3
done

