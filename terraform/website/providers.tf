provider "cloudflare" {
  api_token = data.aws_ssm_parameter.cloudflare_api_token.value
}