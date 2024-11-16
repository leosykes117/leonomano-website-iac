data "cloudflare_zone" "domain" {
  name = var.domain_name
}

resource "cloudflare_record" "aws_acm_domain" {
  for_each = { for opt in aws_acm_certificate.ssl.domain_validation_options : opt.domain_name => opt }
  zone_id  = data.cloudflare_zone.domain.zone_id
  name     = join(".", slice(split(".", each.value.resource_record_name), 0, 2))
  content  = trimsuffix(each.value.resource_record_value, ".")
  type     = each.value.resource_record_type
  ttl      = 3600
}

resource "cloudflare_record" "cloudfront_distribution" {
  zone_id = data.cloudflare_zone.domain.zone_id
  name    = var.env == "prod" ? "" : var.env
  content = module.cloudfront.cloudfront_distribution_domain_name
  type    = "CNAME"
  ttl     = 300
}
