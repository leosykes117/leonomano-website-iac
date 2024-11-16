variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "aws_region" {
  description = "Region de AWS para todos los recursos"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Nombre del ambiente que se está trabajando"
  type        = string
}

variable "delete_bucket_hosting" {
  description = "Indica si debe eliminar al bucket del hosting cuando se aplique un destroy"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Nombre del dominio para el sitio web"
  type        = string
}

variable "aws_cloudfront_wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this to false will skip the process."
  type        = bool
  default     = false
}

variable "aws_cloudfront_create_oac" {
  description = "Controls if CloudFront origin access control should be created"
  type        = bool
  default     = true
}

variable "aws_cloudfront_distribution_errors_response" {
  description = "Custom error responses"
  type = list(object({
    error_code            = number
    response_code         = optional(number)
    response_page_path    = optional(string)
    error_caching_min_ttl = optional(number)
  }))
  default = []
}

variable "default_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}
