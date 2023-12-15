output "instances" {
  # Возвращает внешний ip адрес, имя пользователя и название диска созданных серверов
  value = [
    for instance in google_compute_instance.vm : {
      name    = instance.name
      ip      = instance.network_interface.0.access_config.0.nat_ip
      disk = try("disk/by-id/google-${instance.attached_disk.0.device_name}", null)
    }
  ]
}
