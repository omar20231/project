resource "aws_acm_certificate" "cert-1" {
  domain_name       = local.domain_name
  validation_method = local.validation_method

  tags = {
    Environment = local.env
  }

  lifecycle {
    create_before_destroy = true
  }
}