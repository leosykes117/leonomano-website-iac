variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Name of the environment being used"
  type        = string
}

variable "default_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "delete_bucket_artifact" {
  description = "Indicates whether the bucket for pipeline artifacts should be deleted"
  type        = bool
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
