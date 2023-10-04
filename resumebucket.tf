resource "aws_s3_bucket" "example" {
  bucket = "franciscobalart.io"
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.example.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
# https://stackoverflow.com/questions/76049290/error-accesscontrollistnotsupported-when-trying-to-create-a-bucket-acl-in-aws
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.example.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "my-static-website" {
  bucket = aws_s3_bucket.example.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_object" "index_html" {
  bucket = "franciscobalart.io"  # Replace with your bucket name
  key    = "index.html"
  content_type = "text/html"
  content = <<-EOF
  <!DOCTYPE html>
  <html>
  <head>
      <title>PDF in HTML</title>
  </head>
  <body>
      <center>
          <h1 style="color: green">GeeksforGeeks</h1>
          <h3>Embedding the PDF file Using Object Tag</h3>
          <object data="https://s3.amazonaws.com/franciscobalart.io/franciscoresume2023.pdf" width="800" height="500">
          </object>
      </center>
  </body>
  </html>
  EOF
  depends_on = [aws_s3_bucket.example]
}

resource "aws_s3_bucket_object" "error_html" {
  bucket = aws_s3_bucket.example.bucket
  key    = "error.html"
  content_type = "text/html"
  content = <<-EOF
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Error</title>
    </head>
    <body>
        <p>ThePrimeAgen</p>
    </body>
    </html>
  EOF
  depends_on = [aws_s3_bucket.example]
}

#resource "aws_s3_bucket_policy" "bucket_policy" {
#  bucket = aws_s3_bucket.example.id
#  policy = data.aws_iam_policy_document.bucket_policy_document.json
#}

output "website_url" {
  value = aws_s3_bucket.example.website_endpoint
}

output "bucket_domain_name" {
  value = aws_s3_bucket.example.bucket_regional_domain_name
}