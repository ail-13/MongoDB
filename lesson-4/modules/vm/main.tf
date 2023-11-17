resource "google_compute_instance" "vm" {
  # Создаем виртуальную машину
  name         = var.vm_name
  machine_type = "e2-micro"
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
    ssh-keys = "${var.username}:${file(var.public_key_path)}"
  }

  connection {
    type = "ssh"
    user = var.username
    # Указывает Terraform что нужно использовать ключ из ssh-агента. Для этого должен быть запущен Pagent и там должен быть ключ
    agent = true
    host  = google_compute_instance.vm.network_interface.0.access_config.0.nat_ip
  }

  provisioner "file" {
    # Копируем файлы конфигурации MongoDB
    source      = "files/db"
    destination = "/tmp/db"
  }
  provisioner "file" {
    # Копируем файлы конфигурации клиента
    source      = "files/client"
    destination = "/tmp/client"
  }
  provisioner "remote-exec" {
    # Форматируем и монтируем отдельный диск для базы данных
    script = "scripts/disk_prepare.sh"
  }
  provisioner "remote-exec" {
    # Устанавливаем Docker
    script = "scripts/docker_install.sh"
  }
  provisioner "remote-exec" {
    # Создаем образ с установленной MongoDB и образ с клиентом. И запускаем контейнеры из созданных образов
    script = "scripts/docker_container.sh"
  }
}
resource "google_compute_disk" "disk" {
  # Создаем отдельный диск для базы данных
  # https://gcloud-compute.com/disks.html
  name = "${var.vm_name}-db-disk"
  size = 10
  type = "pd-ssd"
  zone = var.zone
}
