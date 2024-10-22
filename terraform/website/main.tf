module "current_user" {
  source = "../modules/current-user"
}

output "current_user" {
  value = module.current_user.details
}