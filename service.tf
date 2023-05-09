resource "google_cloud_run_service" "cloud_run_service" {
  name     = var.cloud_run_service_name
  location = var.region

  template {
    spec {
      containers {
        image = "${var.artifact_registry_location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.artifact_registry.repository_id}/${var.cloud_run_service_image_name}:${var.cloud_run_service_container_version}"
      }
      service_account_name = var.cloud_run_service_account
      vpc_connector {
        name = var.vpc_access_connector
      }
      network {
        name            = google_compute_network.vpc_network.name
        subnetwork_name = google_compute_subnetwork.vpc_subnet.name
      }
    }
  }
}