module "acm" {
  source  = "terraform-aws-modules/acm/aws"

  domain_name  = "franciscobalart.io"
  zone_id      = "Z2ES7B9AZ6SHAE"

  subject_alternative_names = [
    "*.franciscobalart.io",
    "franciscobalart.io",
  ]

  wait_for_validation = true

  tags = {
    Name = "franciscobalart.io"
  }
}