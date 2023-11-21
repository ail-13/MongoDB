resource "google_compute_firewall" "firewall_ssh" {
  name = "${var.name}-allow-ssh"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = var.source_ranges

  target_tags = [var.name]
}
resource "google_compute_firewall" "firewall_mongo" {
  name    = "${var.name}-allow-mongo"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["27001"]
  }
  source_ranges = var.source_ranges

  target_tags = [var.name]
}