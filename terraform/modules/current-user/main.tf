data "aws_caller_identity" "current" {}

output "details" {
  value = data.aws_caller_identity.current
}