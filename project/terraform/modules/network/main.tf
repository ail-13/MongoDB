resource "google_compute_network" "this" {
  name                    = "${var.vapp_name}-${var.network_name}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  name          = "${var.vapp_name}-${var.network_name}-subnet"
  network       = google_compute_network.this.id
  ip_cidr_range = var.network_ip_range
  region        = var.region
}
