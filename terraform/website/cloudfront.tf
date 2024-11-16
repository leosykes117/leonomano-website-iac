data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "3.4.1"

  aliases             = [local.domain_name]
  comment             = "Distribution for ${local.domain_name} website"
  enabled             = true
  staging             = false # If you want to create a staging distribution, set this to true
  http_version        = "http2"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = var.aws_cloudfront_wait_for_deployment
  default_root_object = "index.html"

  create_origin_access_control = var.aws_cloudfront_create_oac
  origin_access_control = {
    s3_oac = {
      description      = "CloudFront access to bucket"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    s3_oac = {
      domain_name           = module.s3_bucket_hosting.s3_bucket_bucket_regional_domain_name
      origin_access_control = "s3_oac" # key in `origin_access_control`
      connection_attempts   = 3
      connection_timeout    = 10
      origin_shield = {
        enabled              = true
        origin_shield_region = var.aws_region
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_oac"
    path_pattern           = "*"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id
    use_forwarded_values   = false
  }

  viewer_certificate = {
    acm_certificate_arn            = aws_acm_certificate.ssl.arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  # custom_error_response = var.aws_cloudfront_distribution_errors_response

  depends_on = [
    aws_acm_certificate_validation.ssl
  ]
}
