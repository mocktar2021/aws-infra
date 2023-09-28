# Define the provider (AWS in this case)
provider "aws" {
  region = "us-east-1"  # Change this to your desired AWS region
}

# Create an S3 bucket for your static website
resource "aws_s3_bucket" "website_bucket" {
  bucket = "mocktarltd-aue1-asmita2"  # Change this to a unique name
#   acl    = "public-read"      # Allow public read access for static website files

  website {
    index_document = "index.html"  # The default index file
    error_document = "error.html"  # The error page
  }
}

# Create a CloudFront distribution for your website
resource "aws_cloudfront_distribution" "website_cdn" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.website_endpoint
    origin_id   = "S3Origin"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  # Your domain name or leave it empty to generate one
  aliases = ["asmita2.mocktar.com"]  # Change this to your domain

  # Viewer certificate for HTTPS (you can use ACM or IAM certificate)
  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:us-east-1:338492938289:certificate/21c1a329-fa2b-4a6c-8537-d123c5c5e67b"
    ssl_support_method = "sni-only"
  }

  # Restrict access by IP if needed
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Other CloudFront settings...

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "S3-origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl               = 0
    default_ttl           = 3600
    max_ttl               = 86400
  }
}
