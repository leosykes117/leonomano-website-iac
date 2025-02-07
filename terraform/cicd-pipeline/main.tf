module "current_identity" { source = "../modules/current-user" }

resource "aws_codestarconnections_connection" "github_source_code" {
  name          = local.aws_codestar_connection_github_name
  provider_type = "GitHub"

  tags = merge(local.merged_tags, {})
}
