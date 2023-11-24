resource "google_compute_instance" "vm" {
  # Создаем виртуальную машину
  name         = var.vm_name
  machine_type = "e2-small"
  zone         = var.zone
  tags         = [var.vm_name]
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
    }
  }
  attached_disk {
    source      = "${var.vm_name}-db-disk"
    device_name = "mongo-disk"
  }
  network_interface {
    network = "default"
    access_config {}
  }
  metadata = {
    ssh-keys = "${var.username}:${file("${var.private_key_path}.pub")}"
  }

  connection {
    type = "ssh"
    user = var.username
    # Указывает Terraform что нужно использовать ключ из ssh-агента. Для этого должен быть запущен Pagent и там должен быть ключ
    # agent = true
    private_key = file(var.private_key_path)
    host  = google_compute_instance.vm.network_interface.0.access_config.0.nat_ip
  }

  depends_on = [google_compute_disk.disk]
}
resource "google_compute_disk" "disk" {
  # Создаем отдельный диск для базы данных
  # https://gcloud-compute.com/disks.html
  name = "${var.vm_name}-db-disk"
  size = 10
  type = "pd-ssd"
  zone = var.zone
}
