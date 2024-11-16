resource "aws_acm_certificate" "ssl" {
  domain_name       = local.domain_name
  validation_method = "DNS"

  tags = merge(local.default_tags, {
    Name = local.domain_name
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "ssl" {
  certificate_arn = aws_acm_certificate.ssl.arn
}