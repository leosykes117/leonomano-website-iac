output "workspace" {
  description = "Nombre del workspace actual"
  value       = var.env
}

output "project_name" {
  description = "Nombre del proyecto"
  value       = var.project_name
}

output "account_id" {
  value = module.current_identity.details.account_id
}

output "caller_arn" {
  value = module.current_identity.details.arn
}

output "s3_bucket_bucket_regional_domain_name" {
  value = module.s3_bucket_hosting.s3_bucket_bucket_regional_domain_name
}

output "s3_bucket_website_endpoint" {
  value = module.s3_bucket_hosting.s3_bucket_website_endpoint
}

output "aws_acm_certificate_status" {
  value = aws_acm_certificate.ssl.status
}

output "aws_acm_certificate_validation_id" {
  value = aws_acm_certificate_validation.ssl.id
}