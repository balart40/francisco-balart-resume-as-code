module "acm" {
  source  = "terraform-aws-modules/acm/aws"

  domain_name  = "franciscobalart.io"
  zone_id      = "Z0829085HFUZ837P3585"

  subject_alternative_names = [
    "*.franciscobalart.io",
    "franciscobalart.io",
  ]

  wait_for_validation = false

  tags = {
    Name = "franciscobalart.io"
  }

  key_algorithm ="RSA_2048"
}