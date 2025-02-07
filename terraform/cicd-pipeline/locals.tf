locals {
  application = "cicd-pipeline"
  merged_tags = merge(var.default_tags, var.tags, { TerraformModule = local.application })

  aws_codepipeline_pipeline_name              = "${var.project_name}-${var.env}-pipeline"
  aws_iam_policy_cicd_tools_manager           = "${var.project_name}-${var.env}-cicd-tools-management"
  aws_iam_policy_s3_artifacts_store_name      = "${var.project_name}-${var.env}-artifacts-store-management"
  aws_iam_policy_s3_website_hosting_name      = "${var.project_name}-${var.env}-website-hosting-management"
  aws_iam_policy_cloudwatch_logs_name         = "${var.project_name}-${var.env}-cloudwatch-send-logs"
  aws_iam_role_service_role_codepipeline_name = "${var.project_name}-${var.env}-codepipeline-service-role"
  aws_iam_role_service_role_codebuild_name    = "${var.project_name}-${var.env}-codebuild-service-role"
  aws_s3_bucket_pipeline_artifact_store_name  = "${var.project_name}-${var.env}-pipeline-artifact-store"
  aws_codestar_connection_github_name         = "${var.project_name}-github"
  aws_codebuild_vue_project_name              = "${var.project_name}-${var.env}-build-vue-project"
  aws_codebuild_project_group_log_name        = "${var.project_name}-${var.env}-build-vue-project"
  aws_s3_bucket_website_hosting_name          = "${var.project_name}.${var.env}.com"
}
