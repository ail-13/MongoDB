resource "google_compute_instance" "vm" {
  count = var.vm_count
  # Создаем виртуальную машину
  name         = "${var.vm_name}-${var.env}-${count.index + 1}"
  machine_type = "e2-small"
  zone         = var.zone
  tags         = ["${var.vm_name}-${var.env}-${count.index + 1}"]
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  }
  dynamic "attached_disk" {
    for_each = var.create_disk ? [1] : []
    content {
      source      = "${var.vm_name}-${var.env}-disk-${count.index + 1}"
      device_name = "${var.vm_name}-disk-${count.index + 1}"
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
  count = var.create_disk ? var.vm_count : 0
  name  = "${var.vm_name}-${var.env}-disk-${count.index + 1}"
  size  = 10
  type  = "pd-ssd"
  zone  = var.zone
}
