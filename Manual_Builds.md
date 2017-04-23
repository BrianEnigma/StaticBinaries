# Static Binaries: Manual Builds

For manual building, you will need to spin up an EC2 instance. A t2.micro should be sufficient. Be sure to create an ssh key (or use an existing one), then shell in to the instance. Once you have a bash prompt on the instance, run the following commands:

1. Copy or `git clone https://github.com/BrianEnigma/StaticBinaries.git` this repository to your EC2 instance.
   1. You may have to `sudo yum install -y git` to first install the git client.
2. `./build_all.sh`
   1. This first installs the build tools.
   2. It then builds the dependencies.
   3. It next builds the tools.
   4. The tools ultimately end up in the ./bin/ folder.

At this point, you have two options. You can `scp` the binaries from the instance, or (if you've created an S3 bucket), you can push the binaries to the bucket. You're on your own with the `scp`, but the S3 bucket method uses the following command:

1. `./push_to_bucket.sh`
   1. This takes four parameters: your access key ID, your secret, your bucket name, and your region. If you have your IAM set up such that your EC2 instance is in a role that can write to an S3 bucket, then you can use the `push_to_bucket_via_role.sh` script, which only takes the bucket name and region. In this case, the account permissions are implied — inherited from the instance's role.

Voila! You have a collection of static binaries in your bucket. You can then have other EC2 instances grab them, or you can manually grab them and package them into a zip to send to Lambda.