output "mongodb_ip" {
  value = module.vm.external_ip
}

output "mongodb_user" {
  value = var.username
}

output "mongodb_disk" {
  value = module.vm.disk_name
}