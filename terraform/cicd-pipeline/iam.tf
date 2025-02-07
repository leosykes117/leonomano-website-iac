
################################################################################
# JSON de la trust policy para la ejecucion de los resolvers lambda
################################################################################
data "aws_iam_policy_document" "trust_policy_codepipeline" {
  statement {
    sid     = "GetSecurityCredentials"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

################################################################################
# Politica para manegar las herramientas de CICD
# (CodePipeline, CodeBuild, CodeStar Connections)
################################################################################
data "aws_iam_policy_document" "cicd_tools" {
  statement {
    sid = "AllowCodeBuildActions"
    actions = [
      "codebuild:BatchGetBuildBatches",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:StartBuildBatch"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:codebuild:${var.aws_region}:${module.current_identity.details.account_id}:project/${var.project_name}*"
    ]
  }
  statement {
    sid = "AllowCodeDeployActions"
    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication*",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:codedeploy:${var.aws_region}:${module.current_identity.details.account_id}:application:${var.project_name}*",
      "arn:aws:codedeploy:${var.aws_region}:${module.current_identity.details.account_id}:deploymentgroup:${var.project_name}*",
      "arn:aws:codedeploy:${var.aws_region}:${module.current_identity.details.account_id}:deploymentconfig:${var.project_name}*"
    ]
  }

  statement {
    sid = "AllowCodeStarConnectionActions"
    actions = [
      "codestar-connections:UseConnection"
    ]
    resources = [
      aws_codestarconnections_connection.github_source_code.arn
    ]
  }
}

resource "aws_iam_policy" "cicd_tools_management" {
  name        = local.aws_iam_policy_cicd_tools_manager
  path        = "/"
  description = "Politica que permite crear y ejecutar builds de codebuild"
  policy      = data.aws_iam_policy_document.cicd_tools.json
  tags        = merge(local.merged_tags, {})
}

################################################################################
# Politica para leer y escribir artefactos en el bucket del CodePipeline
################################################################################
data "aws_iam_policy_document" "s3_artifacts_store" {
  statement {
    sid    = "AllowUseBucket"
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetObject",
      "s3:ListMultipartUploadParts",
      "s3:PutObject"
    ]
    resources = [
      "${module.pipeline_artifact_storage.s3_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_artifacts_store" {
  name        = local.aws_iam_policy_s3_artifacts_store_name
  path        = "/"
  description = "Politica que permite escribir y leer en el bucket S3 de los artefactos de pipeline"
  policy      = data.aws_iam_policy_document.s3_artifacts_store.json
  tags        = merge(local.merged_tags, {})
}

################################################################################
# Politica para crear y realizar modificaciones al bucket del sitio web
################################################################################
data "aws_iam_policy_document" "s3_website_hosting" {
  statement {
    sid    = "AllowCreateModifyWebSiteHosting"
    effect = "Allow"
    actions = [
      "s3:CreateBucket",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:PutObject",
      # [ DeleteBucketPolicy, GetBucketPolicy, GetBucketPolicyStatus, PutBucketPolicy ]
      "s3:*BucketPolicy*",
      # [ DeleteBucketWebsite, GetBucketWebsite, PutBucketWebsite ]
      "s3:*BucketWebsite",
      # [ DeleteObject, DeleteObjectTagging, DeleteObjectVersion, DeleteObjectVersionTagging ]
      "s3:DeleteObject*",
      # [ GetBucketAcl, PutBucketAcl ]
      "s3:*BucketAcl",
      # [ GetBucketCORS, PutBucketCORS ]
      "s3:*BucketCORS",
      # [ GetBucketLogging, PutBucketLogging ]
      "s3:*BucketLogging",
      # [ GetBucketNotification, PutBucketNotification ]
      "s3:*BucketNotification",
      # [ GetBucketOwnershipControls, PutBucketOwnershipControls ]
      "s3:*BucketOwnershipControls",
      # [ GetBucketPublicAccessBlock, PutBucketPublicAccessBlock ]
      "s3:*BucketPublicAccessBlock",
      # [ GetBucketTagging, PutBucketTagging ]
      "s3:*BucketTagging",
      # [ GetBucketVersioning, PutBucketVersioning ]
      "s3:*BucketVersioning",
      # [ GetEncryptionConfiguration, PutEncryptionConfiguration ]
      "s3:*EncryptionConfiguration",
      # [ GetObjectTagging, PutObjectTagging ]
      "s3:*ObjectTagging",
      # [ GetObjectVersionTagging, PutObjectVersionTagging ]
      "s3:*ObjectVersionTagging",
      # [ ListBucket, ListBucketMultipartUploads, ListBucketVersions ]
      "s3:ListBucket*"
    ]
    resources = [
      "arn:aws:s3:::${local.aws_s3_bucket_website_hosting_name}",
      "arn:aws:s3:::${local.aws_s3_bucket_website_hosting_name}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_website_hosting" {
  name        = local.aws_iam_policy_s3_website_hosting_name
  path        = "/"
  description = "Politica que permite escribir y leer en el bucket S3 de los artefactos de pipeline"
  policy      = data.aws_iam_policy_document.s3_website_hosting.json
  tags        = merge(local.merged_tags, {})
}

################################################################################
# Politica para crear y enviar logs a CloudWatchLogs
################################################################################
data "aws_iam_policy_document" "cloudwatch_logs" {
  statement {
    sid = "AllowSendLogsToCloudWatch"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:logs:${var.aws_region}:${module.current_identity.details.account_id}:log-group:*${var.project_name}*",
      "arn:aws:logs:${var.aws_region}:${module.current_identity.details.account_id}:log-group:*${var.project_name}*:log-stream:*"
    ]
  }
}

resource "aws_iam_policy" "cloudwatch_logs" {
  name        = local.aws_iam_policy_cloudwatch_logs_name
  path        = "/"
  description = "Politica que permite enviar logs de la ejecucion del build a CloudWatch Logs"
  policy      = data.aws_iam_policy_document.cloudwatch_logs.json
  tags        = merge(local.merged_tags, {})
}

################################################################################
# Service Role para la ejecución del pipeline
################################################################################
resource "aws_iam_role" "codepipeline_service_role" {
  name               = local.aws_iam_role_service_role_codepipeline_name
  description        = "Role encargado de la ejecución del pipeline de CICD"
  path               = "/service-role/codepipeline/"
  assume_role_policy = data.aws_iam_policy_document.trust_policy_codepipeline.json
  tags = merge(local.merged_tags, {
    Name = local.aws_iam_role_service_role_codepipeline_name
  })
}

resource "aws_iam_role_policy_attachment" "cicd_tools_management_policy" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = aws_iam_policy.cicd_tools_management.arn
}

resource "aws_iam_role_policy_attachment" "s3_artifacts_store_policy" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = aws_iam_policy.s3_artifacts_store.arn
}

resource "aws_iam_role_policy_attachment" "s3_website_hosting_policy" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = aws_iam_policy.s3_website_hosting.arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs.arn
}
