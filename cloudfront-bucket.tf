resource "aws_s3_bucket" "resume_as_code_cdn_bucket" {
  bucket = "resume-as-code-cdn-logs"
}

resource "aws_s3_bucket_ownership_controls" "resume_as_code_cdn_bucket_controls" {
  bucket = aws_s3_bucket.resume_as_code_cdn_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "resume_as_code_cdn_bucket_block" {
  bucket = aws_s3_bucket.resume_as_code_cdn_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "resume_as_code_cdn_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.resume_as_code_cdn_bucket_controls,
    aws_s3_bucket_public_access_block.resume_as_code_cdn_bucket_block,
  ]

  bucket = aws_s3_bucket.resume_as_code_cdn_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = "resume-as-code-cdn-logs"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "arn:aws:s3:::resume-as-code-cdn-logs/*"
    }]
  })
}