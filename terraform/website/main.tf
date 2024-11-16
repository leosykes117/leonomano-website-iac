
locals {
  application  = "website"
  default_tags = merge(var.default_tags, { TerraformModule = local.application })

  aws_s3_bucket_hosting = "${var.project_name}.${var.env}.com"
  domain_name           = "${var.env}.${var.domain_name}"
}

module "current_identity" {
  source = "../modules/current-user"
}

data "aws_ssm_parameter" "cloudflare_api_token" {
  name = "/account-configuration/${var.aws_region}/${var.env}/cloudflare_api_token"
}