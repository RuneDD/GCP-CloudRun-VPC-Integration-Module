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

  service = each.key

  project            = var.project_id
  disable_on_destroy = false
}
