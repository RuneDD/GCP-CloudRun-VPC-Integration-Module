# Services enabled by the module
resource "google_project_service" "project-services" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "vpcaccess.googleapis.com",
    "logging.googleapis.com",
    "serviceusage.googleapis.com",
  ])
  service            = each.key
  project            = var.project_id
  disable_on_destroy = false
}
# VPC components
resource "google_compute_network" "vpc_network" {
  count                   = var.enable_vpc
  name                    = var.vpc_network_name
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "vpc_subnetwork" {
  count         = var.enable_vpc
  name          = var.vpc_subnet_name
  region        = var.region
  ip_cidr_range = var.vpc_subnet_ip_cidr_range
  network       = google_compute_network.vpc_network.id
  depends_on    = [google_compute_network.vpc_network]
}
resource "google_compute_subnetwork" "vpc_access_connector_subnet" {
  count         = var.enable_vpc
  name          = var.vpc_connector_subnet_name
  region        = var.region
  ip_cidr_range = var.vpc_connector_subnet_ip_cidr_range
  network       = google_compute_network.vpc_network.id
  depends_on    = [google_compute_network.vpc_network]
}
resource "google_vpc_access_connector" "vpc_access_connector" {
  count        = var.enable_vpc
  name         = var.vpc_connector_name
  region       = var.region
  machine_type = var.vpc_connector_machine_type
  subnet {
    name = google_compute_subnetwork.vpc_access_connector_subnet.name
  }
}
locals {
  common_annotations = {
    # Scaling behaviour
    "autoscaling.knative.dev/maxScale" = var.cloud_run_max_scale
    "autoscaling.knative.dev/minScale" = var.cloud_run_min_scale
    "run.googleapis.com/vpc-access-egress" = var.cloud_run_vpc_access_egress
    # Set to true to enable CPU allocation only during request processing
    "run.googleapis.com/cpu-throttling" = var.cloud_run_cpu_throttling
    # Set to true to enable requests from a client to be directed to the same container
    "run.googleapis.com/sessionAffinity" = var.cloud_run_session_affinity
    # Set to true to enable CPU boosts to reduce startup time
    "run.googleapis.com/startup-cpu-boost" = var.cloud_run_cpu_boost
  }
  vpc_connector_annotation = var.enable_vpc == 1 ? {
    "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.vpc_access_connector[0].name
  } : {}
}
resource "google_cloud_run_service" "cloud_run_service" {
  name     = var.cloud_run_service_name
  location = var.region
  project  = var.project_id
  metadata {
    namespace = var.project_id
    annotations = {
      "run.googleapis.com/ingress" = var.cloud_run_vpc_access_ingress
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
  template {
    spec {
      container_concurrency = var.cloud_run_container_concurrency
      timeout_seconds       = var.cloud_run_timeout_seconds
      service_account_name  = var.cloud_run_service_account
      containers {
        image = var.cloud_run_service_image_location
        resources {
          requests = {
            cpu    = var.cloud_run_cpu_request
            memory = var.cloud_run_memory_request
          }
          limits = {
            cpu    = var.cloud_run_cpu_limit
            memory = var.cloud_run_memory_limit
          }
        }
        ports {
          container_port = var.cloud_run_container_port
        }
      }
    }
    metadata {
      labels = {
        "environment" : terraform.workspace
        "run.googleapis.com/startupProbeType" = "Default"
      }
      annotations = merge(local.common_annotations, local.vpc_connector_annotation)
    }
  }
  autogenerate_revision_name = true
}
# allow unauthenticated Requests
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers"
    ]
  }
}
resource "google_cloud_run_service_iam_policy" "noauth-env" {
  location    = google_cloud_run_service.cloud_run_service.location
  project     = google_cloud_run_service.cloud_run_service.project
  service     = google_cloud_run_service.cloud_run_service.name
  policy_data = data.google_iam_policy.noauth.policy_data
  depends_on  = [google_cloud_run_service.cloud_run_service]
}