resource "google_compute_instance" "vm" {
  # Создаем виртуальную машину
  name         = "${var.vm_name}-${var.env}"
  machine_type = "e2-small"
  zone         = var.zone
  tags         = ["${var.vm_name}-${var.env}"]
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  }
  dynamic "attached_disk" {
    for_each = var.create_disk ? [1] : []
    content {
      source      = "${var.vm_name}-${var.env}-disk"
      device_name = "${var.vm_name}-disk"
    }
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = "${var.username}:${file("${var.private_key_path}.pub")}"
  }

  depends_on = [google_compute_disk.disk]
}
resource "google_compute_disk" "disk" {
  # Создаем отдельный диск для базы данных
  # https://gcloud-compute.com/disks.html
  count = var.create_disk ? 1 : 0
  name = "${var.vm_name}-${var.env}-disk"
  size = 10
  type = "pd-ssd"
  zone = var.zone
}
