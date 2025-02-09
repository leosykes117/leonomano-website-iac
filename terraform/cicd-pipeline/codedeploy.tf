resource "aws_codepipeline" "website_cicd" {
  name     = local.aws_codepipeline_pipeline_name
  role_arn = aws_iam_role.codepipeline_service_role.arn

  artifact_store {
    location = module.pipeline_artifact_storage.s3_bucket_id
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github_source_code.arn
        FullRepositoryId = "leosykes117/leonomano-website"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.build_vue_project.name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      version         = "1"
      input_artifacts = ["build_output"]
      configuration = {
        BucketName = local.aws_s3_bucket_website_hosting_name
        Extract    = "true"
      }
    }
  }

  tags = merge(local.merged_tags, {})
}
