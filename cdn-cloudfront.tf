module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["franciscobalart.io"]

  comment             = "My awesome CloudFront"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = "My awesome CloudFront can access"
  }

  logging_config = {
    bucket = "resume-as-code-cdn-logs.s3.amazonaws.com"
  }

  origin = {
    something = {
      domain_name = aws_s3_bucket.example.bucket_regional_domain_name
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }

    s3_one = {
      domain_name = aws_s3_bucket.example.bucket_regional_domain_name
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id           = "something"
    viewer_protocol_policy     = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/static/*"
      target_origin_id       = "s3_one"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = "arn:aws:acm:us-east-1:396728917751:certificate/c353b3bc-ca33-49d2-978a-2110eaa4b113"
    ssl_support_method  = "sni-only"
  }
}