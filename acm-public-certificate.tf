module "acm" {
  source  = "terraform-aws-modules/acm/aws"

  domain_name  = "franciscobalart.io"
  zone_id      = "Z05309372P5K06T9KRT76"

  subject_alternative_names = [
    "www.franciscobalart.io",
  ]

  wait_for_validation = false

  tags = {
    Name = "franciscobalart.io"
  }

  key_algorithm ="RSA_2048"
}