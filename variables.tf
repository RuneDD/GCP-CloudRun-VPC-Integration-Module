variable "project_id" {
  description = "The ID of the GCP project where the resources will be created."
  default     = "vbridge-personal-rune"
}

variable "region" {
  description = "The region where the resources will be created."
  default     = "europe-west1"
}

variable "vpc_network_name" {
  description = "The name of the VPC network to create."
  default     = "vpc-network"
}

variable "vpc_subnet_name" {
  description = "The name of the VPC subnet to create."
  default     = "vpc-sub-network"
}

variable "vpc_subnet_ip_cidr_range" {
  description = "The IP CIDR range for the VPC subnet."
  default     = "10.0.0.0/24"
}

variable "vpc_connector_name" {
  description = "The name of the VPC connector."
  default     = "vpc-access-connector"
}

variable "vpc_connector_subnet_name" {
  description = "The name of the VPC connector subnet to create."
  default     = "vpc-connector-sub-network"
}

variable "vpc_connector_subnet_ip_cidr_range" {
  description = "The IP CIDR range for the VPC connector subnet."
  default     = "10.100.0.0/28"
}

variable "vpc_connector_machine_type" {
  description = "The machine type of the VPC access connector."
  default     = "e2-micro"
}

variable "artifact_registry_name" {
  description = "The name of the Artifact Registry to create."
  default     = "artifacts-registry"
}

variable "artifact_registry_location" {
  description = "The location of the Artifact Registry."
  default     = "europe-west1"
}

variable "cloud_run_service_name" {
  description = "The name of the Cloud Run service to create."
  default     = "cloud-run-service"
}

variable "cloud_run_service_image_name" {
  description = "The name of the image to use for the Cloud Run service."
  default     = "cloud-run-service-image"
}

variable "cloud_run_service_container_version" {
  description = "The version of the container to use for the Cloud Run service."
  default     = "latest"
}

# variable "cloud_run_service_account" {
#   description = "The service account used to run the service."
# }