# Static Binary Scripts

## What?

This is a collection of scripts that can be run on an EC2 instance and which will generate static binaries for:

- libpng
- libjpeg
- ffmpeg/ffprobe/ffserver, with its own static copy of x264
- ImageMagick
- sox

Optionally, another script can upload the resulting files to an S3 bucket.

## Why?

Why would you want to do this? Two reasons:

1. Due to patent licensing, it is illegal to distribute ffmpeg and other tools in binary form in certain jurisdictions.
2. Some environments, such as AWS Lambda, require a nice neat package with minimal OS-level shared library dependencies. These binaries depend on a few libs that are always present, for instance libc, but nothing special.

## How?

1. Copy or `git clone` this repository to your EC2 instance.
   1. You may have to `sudo yum install -y git` to first install the git client.
2. `./build_all.sh`
   1. This first installs the build tools.
   2. It then builds the dependencies.
   3. It next builds the tools.
   4. The tools ultimately end up in the ./bin/ folder.
3. `./push_to_bucket.sh`
   1. This takes four parameters: your access key ID, your secret, your bucket name, and your region.

Voila! You have a collection of static binaries in your bucket. You can then have other EC2 instances grab them, or you can manually grab them and package them into a zip to send to Lambda.




