resource "google_compute_instance" "this" {
  name         = "${var.vapp_name}-${var.vm_name}-${var.vdc.alias}"
  machine_type = var.vm_machine_type
  zone         = var.vdc.zone
  tags         = ["${var.vapp_name}-${var.vm_name}-${var.vdc.alias}"]
  boot_disk {
    initialize_params {
      image = var.vm_image
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
  metadata = {
    ssh-keys = "${var.vm_username}:${file(var.public_key_path)}"
  }

  metadata_startup_script = <<-EOT
  #! /bin/bash
  sudo sed -i 's/[# ]*Port .*/Port ${var.vm_ssh_port}/' /etc/ssh/sshd_config
  sudo sed -i 's/[# ]*PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
  sudo sed -i 's/[# ]*PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
  sudo systemctl restart sshd
  EOT
}
