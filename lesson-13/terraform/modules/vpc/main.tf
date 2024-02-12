resource "google_compute_firewall" "firewall" {
  count   = var.vm_count
  name    = "${var.vm_name}-${var.env}-${count.index + 1}-allow-${join("-", [for port in var.ports : tostring(port)])}"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = var.ports
  }
  source_ranges = var.source_ranges

  target_tags = ["${var.vm_name}-${var.env}-${count.index + 1}"]
}
