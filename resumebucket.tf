resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = "temporary-resume-bucket"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = "*",
      Action    = "s3:GetObject",
      Resource  = "arn:aws:s3:::temporary-resume-bucket/*"
    }]
  })
}