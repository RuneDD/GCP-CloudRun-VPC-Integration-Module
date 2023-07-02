# Project variables

variable "project_id" {
  description = "The project ID of the GCP project where the resources will be created."
}

variable "region" {
  description = "The region where the resources will be created."
  default     = "europe-west1"
}

# VPC variables

variable "enable_vpc" {
  description = "Whether the VPC components are created"
  default     = 1
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

# Cloud Run Service variables

variable "cloud_run_service_name" {
  description = "The name of the Cloud Run service to create."
  default     = "cloud-run-service"
}

variable "cloud_run_container_concurrency" {
  description = "The number of simultaneous requests that can be processed by each container"
  default     = 30
}

variable "cloud_run_timeout_seconds" {
  description = "The time within which a response must be returned by the service in seconds"
  default     = 180
}

variable "cloud_run_service_account" {
  description = "The service account used to run the service."
}

variable "cloud_run_service_image_location" {
  description = "The location of the image to use for the Cloud Run service."
  default     = "nginx:alpine"
}

variable "cloud_run_cpu_request" {
  description = "The requested cpu specs for the for the Cloud Run service."
  default     = "1000m"
}

variable "cloud_run_memory_request" {
  description = "The requested memory specs for the for the Cloud Run service."
  default     = "1024Mi"
}

variable "cloud_run_cpu_limit" {
  description = "The limited cpu specs for the for the Cloud Run service."
  default     = "2000m"
}

variable "cloud_run_memory_limit" {
  description = "The limited memory specs for the for the Cloud Run service."
  default     = "2048Mi"
}

variable "cloud_run_container_port" {
  description = "The port on which the Cloud Run service will listen"
  default     = 80
}

variable "cloud_run_max_scale" {
  description = "The maximum number of containers that can be scaled up"
  default     = 5
}

variable "cloud_run_min_scale" {
  description = "The minimum number of containers that can be scaled up"
  default     = 0
}

variable "cloud_run_vpc_access_egress" {
  description = "Control outbound network access for the Cloud Run service"
  default     = "private-ranges-only"
}

variable "cloud_run_vpc_access_ingress" {
  description = "Control inbound network access for the Cloud Run service"
  default     = "internal-and-cloud-load-balancing"
}

variable "cloud_run_cpu_throttling" {
  description = "The degree to which the CPU usage of the Cloud Run service is limited during resource allocation"
  default     = true
}

variable "cloud_run_session_affinity" {
  description = "The degree to which requests from a client should be directed to the same container"
  default     = true
}

variable "cloud_run_cpu_boost" {
  description = "The degree to which a CPU boosts should be enabled to reduce startup time"
  default     = true
}