resource "aws_s3_bucket" "example" {
  bucket = var.s3_bucket_name
  acl    = "private"  # Adjust the access control as needed
  # Add any additional configuration for your S3 bucket
}
