################################################################################
# JSON de la trust policy para la ejecución de codebuild
################################################################################
data "aws_iam_policy_document" "trust_policy_codebuild" {
  statement {
    sid     = "GetSecurityCredentials"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

################################################################################
# Service Role para la ejecución del build project
################################################################################
resource "aws_iam_role" "codebuild_service_role" {
  name               = local.aws_iam_role_service_role_codebuild_name
  description        = "Role encargado de la ejecución de los proyectos de CodeBuild"
  path               = "/service-role/codebuild/"
  assume_role_policy = data.aws_iam_policy_document.trust_policy_codebuild.json
  tags = merge(local.merged_tags, {
    Name = local.aws_iam_role_service_role_codebuild_name
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_role_s3_artifacts_store_policy" {
  policy_arn = aws_iam_policy.s3_artifacts_store.arn
  role       = aws_iam_role.codebuild_service_role.name
}

resource "aws_iam_role_policy_attachment" "codebuild_role_cloudwatch_logs_policy" {
  policy_arn = aws_iam_policy.cloudwatch_logs.arn
  role       = aws_iam_role.codebuild_service_role.name
}
