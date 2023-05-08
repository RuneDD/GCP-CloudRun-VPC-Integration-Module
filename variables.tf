variable "project_id" {
  description = "The ID of the GCP project where the resources will be created."
}

variable "region" {
  description = "The region where the resources will be created."
  default     = "us-central1"
}

variable "vpc_network_name" {
  description = "The name of the VPC network to create."
  default     = "${var.project_id}-vpc"
}

variable "vpc_subnet_name" {
  description = "The name of the VPC subnet to create."
  default     = "${var.project_id}-vpc-sub"
}

variable "vpc_subnet_ip_cidr_range" {
  description = "The IP CIDR range for the VPC subnet."
  default     = "10.0.0.0/24"
}

variable "artifact_registry_name" {
  description = "The name of the Artifact Registry to create."
  default     = "${var.project_id}-registry"
}

variable "artifact_registry_location" {
  description = "The location of the Artifact Registry."
  default     = var.region
}

variable "cloud_run_service_name" {
  description = "The name of the Cloud Run service to create."
  default     = "${var.project_id}-service"
}

variable "cloud_run_service_image_name" {
  description = "The name of the image to use for the Cloud Run service."
  default     = "${var.project_id}-image"
}