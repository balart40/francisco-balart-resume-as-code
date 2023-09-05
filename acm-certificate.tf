module "acm" {
  source  = "terraform-aws-modules/acm/aws"

  domain_name  = "franciscobalart.io"
  zone_id      = "Z0253306O2FTMU8G96C8"

  subject_alternative_names = [
    "*.franciscobalart.io",
    "franciscobalart.io",
  ]

  wait_for_validation = false

  tags = {
    Name = "franciscobalart.io"
  }

  create_route53_records = true

  key_algorithm ="RSA_2048"
}