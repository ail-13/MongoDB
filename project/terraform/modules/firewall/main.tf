resource "google_compute_firewall" "firewall_access" {
  for_each = { for idx, rule in var.firewall_rules : idx => rule }

  name          = "${var.firewall_network}-${each.key}-allow-${join("-", each.value.ports)}"
  network       = var.firewall_network
  source_ranges = each.value.source
  target_tags   = each.value.dest

  allow {
    protocol = "tcp"
    ports    = each.value.ports
  }
}
