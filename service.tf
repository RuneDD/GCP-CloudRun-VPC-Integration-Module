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
      annotations = {
        # Scaling behaviour
        "autoscaling.knative.dev/maxScale" = var.cloud_run_max_scale
        "autoscaling.knative.dev/minScale" = var.cloud_run_min_scale
        # Serverless VPC access connector
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.vpc_access_connector.name
        "run.googleapis.com/vpc-access-egress"    = var.cloud_run_vpc_access_egress
        # Set to true to enable CPU allocation only during request processing
        "run.googleapis.com/cpu-throttling" = var.cloud_run_cpu_throttling
        # Set to true to enable requests from a client to be directed to the same container
        "run.googleapis.com/sessionAffinity" = var.cloud_run_session_affinity
        # Set to true to enable CPU boosts to reduce startup time
        "run.googleapis.com/startup-cpu-boost" = var.cloud_run_cpu_boost
      }
    }
  }
  autogenerate_revision_name = true
}