output "_env" {
  value = "stage"
}

output "mongodb_ip" {
  value = module.db.external_ip
}

output "mongodb_user" {
  value = var.username
}

output "mongodb_disk" {
  value = module.db.disk_name
}

output "app_ip" {
  value = module.app.external_ip
}