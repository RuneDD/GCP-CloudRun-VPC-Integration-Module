resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = var.vpc_subnet_name
  region        = var.region
  ip_cidr_range = var.vpc_subnet_ip_cidr_range
  network       = google_compute_network.vpc_network.id
  depends_on    = [google_compute_network.vpc_network]
}

resource "google_compute_subnetwork" "vpc_access_connector_subnet" {
  name          = var.vpc_connector_subnet_name
  region        = var.region
  ip_cidr_range = var.vpc_connector_subnet_ip_cidr_range
  network       = google_compute_network.vpc_network.id
  depends_on    = [google_compute_network.vpc_network]
}

resource "google_vpc_access_connector" "vpc_access_connector" {
  name         = var.vpc_connector_name
  region       = var.region
  machine_type = var.vpc_connector_machine_type
  subnet {
    name = google_compute_subnetwork.vpc_access_connector_subnet.name
  }
}