output "external_ip" {
  # Внешний ip адрес созданного сервера
  value = google_compute_instance.vm.network_interface.0.access_config.0.nat_ip
}
