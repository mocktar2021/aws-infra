provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucket_name # Change this to a unique bucket name

  tags = {
    Name = "MyExampleBucket"
    Deployment = "ByTerraform"
    # Project = "Infinity"
  }
}