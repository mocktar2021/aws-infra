provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucket_name # Change this to a unique bucket name
  # acl    = "private"                 # You can change the ACL (Access Control List) as needed

  tags = {
    Name = "MyExampleBucket"
  }
}