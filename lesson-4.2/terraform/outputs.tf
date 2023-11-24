output "mongodb_ip" {
  value = module.vm.external_ip
}

output "mongodb_user" {
  value = var.username
}