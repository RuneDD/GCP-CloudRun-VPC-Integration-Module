resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = var.vpc_subnet_name
  ip_cidr_range = var.vpc_subnet_ip_cidr_range
  network       = google_compute_network.vpc_network.self_link
  region        = var.region
}