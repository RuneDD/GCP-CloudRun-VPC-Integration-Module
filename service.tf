resource "google_cloud_run_service" "cloud_run_service" {
  name     = var.cloud_run_service_name
  location = var.region

  template {
    spec {
      # container_concurrency = 
      # timeout_seconds = 
      service_account_name = var.cloud_run_service_account
      containers {
        image = "${var.artifact_registry_location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.artifact_registry.repository_id}/${var.cloud_run_service_image_name}:${var.cloud_run_service_container_version}"
        # resources {
        #   requests {
        #     cpu = 
        #     memory =
        #   }
        #   limits {
        #     cpu = 
        #     memory =
        #   }
        # }
        # ports {
        #   container_port = 
        # }
      }
    }
  }
  metadata {
    labels = {
      "environment" : terraform.workspace
    }
    annotations = {
      # Scaling behaviour
      # "autoscaling.knative.dev/maxScale" = 
      # "autoscaling.knative.dev/minScale" = 
      # Serverless VPC access connector
      "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.vpc_access_connector.name
      # "run.googleapis.com/vpc-access-egress" = 
      # # Set to true to enable CPU allocation only during request processing
      # "run.googleapis.com/cpu-throttling" = 
      # # Set to true to enable requests from a client to be directed to the same container
      # "run.googleapis.com/sessionAffinity" = 
      # # Set to true to enable CPU boosts to reduce startup time
      # "run.googleapis.com/startup-cpu-boost" = 
    }
  }
}