resource "google_compute_network" "this" {
  name                    = "${var.vapp_name}-${var.network_name}-${var.vdc.alias}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  name          = "${var.vapp_name}-${var.network_name}-${var.vdc.alias}-subnet"
  network       = google_compute_network.this.id
  ip_cidr_range = var.network_ip_range
  region        = var.vdc.region
}
