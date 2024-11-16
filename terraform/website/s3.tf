data "aws_iam_policy_document" "allow_cloudfront_read_from_s3" {
  policy_id = "AllowAccessToCloudFrontDistribution"
  statement {
    sid = "AllowCloudFrontServicePrincipal"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = ["${module.s3_bucket_hosting.s3_bucket_arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cloudfront.cloudfront_distribution_arn]
    }
  }
}

module "s3_bucket_hosting" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.2"

  bucket        = local.aws_s3_bucket_hosting
  force_destroy = var.delete_bucket_hosting

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  attach_policy = true
  policy        = data.aws_iam_policy_document.allow_cloudfront_read_from_s3.json

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  website = {
    index_document = "index.html"
  }

  tags = local.default_tags

  # Versioning
  /* versioning = {
    status = true
  }*/
}
