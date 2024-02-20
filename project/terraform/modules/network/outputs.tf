output "network" {
  description = "Название сети"
  value       = google_compute_network.this.name
}
output "subnetwork" {
  description = "Название подсети"
  value       = google_compute_subnetwork.this.name
}
