module "pipeline_artifact_storage" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.5.0"

  bucket        = local.aws_s3_bucket_pipeline_artifact_store_name
  force_destroy = var.delete_bucket_artifact

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(local.merged_tags, {
    Name        = local.aws_s3_bucket_pipeline_artifact_store_name
    Description = "Bucket para alojar los artefactos generados por el pipeline del proyecto ${var.project_name}"
  })
}
