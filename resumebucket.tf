resource "aws_s3_bucket" "example" {
  bucket = "franciscobalart.io"
}

resource "aws_s3_bucket_website_configuration" "my-static-website" {
  bucket = aws_s3_bucket.example.id

  index_document {
    suffix = "franciscoresume2023.pdf"
  }

  error_document {
    key = "franciscoresume2023.pdf"
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.example.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = "franciscobalart.io"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "arn:aws:s3:::franciscobalart.io/*"
    }]
  })
}

output "website_url" {
  value = "http://franciscobalart.io.s3-website.us-east-1.amazonaws.com"
}