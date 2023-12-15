resource "google_compute_firewall" "firewall_ssh" {
  count = var.vm_count
  name = "${var.name}-${var.env}-${count.index + 1}-allow-ssh"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = var.source_ranges

  target_tags = ["${var.name}-${var.env}-${count.index + 1}"]
}
resource "google_compute_firewall" "firewall_mongo" {
  count = var.vm_count
  name    = "${var.name}-${var.env}-${count.index + 1}-allow-mongo"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["27001"]
  }
  source_ranges = var.source_ranges

  target_tags = ["${var.name}-${var.env}-${count.index + 1}"]
}