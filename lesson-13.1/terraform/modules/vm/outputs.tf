output "name" {
  description = "Название ВМ"
  value       = google_compute_instance.this.name
}
output "internal_ip" {
  description = "Внутренний IP"
  value       = [for item in var.vm_networks : item.subnetwork_ip]
}
output "external_ip" {
  description = "Внешний IP"
  value       = google_compute_instance.this.network_interface.0.access_config.0.nat_ip
}
output "ssh_port" {
  description = "Порт SSH"
  value       = var.vm_ssh_port
}
output "disk" {
  description = "Название дополнительного диска"
  value       = try("disk/by-id/google-${google_compute_instance.this.attached_disk.0.device_name}", null)
}
output "metadata" {
  description = "value"
  value = { for key, value in google_compute_instance.this.metadata : key => value if key != "" && key != "ssh-keys" }
}
