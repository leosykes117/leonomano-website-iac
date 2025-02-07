output "workspace" {
  description = "Nombre del workspace actual"
  value       = var.env
}

output "project_name" {
  description = "Nombre del proyecto"
  value       = var.project_name
}

output "account_id" {
  description = "Current Account ID"
  value       = module.current_identity.details.account_id
}

output "caller_arn" {
  description = "Current Identity Caller ARN"
  value       = module.current_identity.details.arn
}
