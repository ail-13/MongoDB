resource "google_compute_instance" "this" {
  name         = "${var.vapp_name}-${var.vm_name}"
  machine_type = var.vm_machine_type
  zone         = var.zone
  tags         = ["${var.vapp_name}-${var.vm_name}"]
  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }
  dynamic "attached_disk" {
    for_each = var.vm_data_disk_size > 0 ? [1] : []
    content {
      source      = "${var.vapp_name}-${var.vm_name}-data"
      device_name = "${var.vapp_name}-${var.vm_name}-data"
    }
  }
  dynamic "network_interface" {
    for_each = var.vm_networks
    content {
      network    = network_interface.value.network
      subnetwork = network_interface.value.subnetwork
      network_ip = network_interface.value.subnetwork_ip
      access_config {}
    }
  }
  metadata = merge(
    { for item in var.vm_metadata : item.key => item.value },
    {
      ssh-keys = "${var.vm_username}:${file(var.public_key_path)}"
    }
  )

  metadata_startup_script = <<-EOT
  #! /bin/bash
  sudo sed -i 's/[# ]*Port .*/Port ${var.vm_ssh_port}/' /etc/ssh/sshd_config
  sudo sed -i 's/[# ]*PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
  sudo sed -i 's/[# ]*PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
  sudo systemctl restart sshd
  EOT

  depends_on = [google_compute_disk.this]
}
resource "google_compute_disk" "this" {
  # Создаем отдельный диск для сервера
  # https://gcloud-compute.com/disks.html
  count = var.vm_data_disk_size > 0 ? 1 : 0
  name  = "${var.vapp_name}-${var.vm_name}-data"
  size  = var.vm_data_disk_size
  type  = "pd-ssd"
  zone  = var.zone
}
