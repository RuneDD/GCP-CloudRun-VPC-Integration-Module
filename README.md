# Terraform GCP Cloud Run with VPC Integration Module

This [Terraform](https://terraform.io) module, **GCP CloudRun VPC Integration Module**, is designed to streamline the deployment of [Google Cloud Run](https://cloud.google.com/run/docs/overview/what-is-cloud-run) services, seamlessly integrated with a [VPC network](https://cloud.google.com/vpc/docs/vpc) and a VPC connector. This module allows you to configure your Cloud Run service to establish secure communication with your VPC resources and private databases within the [Google Cloud Platform (GCP)](https://cloud.google.com) ecosystem.

Please note: The creation of VPC components is optional. Depending on the specific needs of your project, you may choose whether or not to implement these.

## Prerequisites

Before you begin, ensure you have the following:

- Terraform `v1.x.x` installed
- [Google Cloud SDK](https://cloud.google.com/sdk) installed and configured with a valid project
- Proper IAM roles and permissions in GCP
- Generated a service account key in JSON format and stored it in a secure place

The `provider` block is not included in this code. You should configure it at root level of your project:

```hcl
provider "google" {
  credentials = file("<PATH_TO_SERVICE_ACCOUNT_KEY_JSON>")
  project     = "<PROJECT_ID>"
  region      = "europe-west1"
}
```

In the example above, replace `<PATH_TO_SERVICE_ACCOUNT_KEY_JSON>` with the path to your Service Account key JSON file and `<PROJECT_ID>` with your GCP Project ID. Also, be aware that you will need to provide a storage location for the Terraform state to be kept in.

## Configuration variables

The module uses the following variables for customization:

### Project variables

- `project_id`: The GCP project's ID where resources will be deployed. **(required)**
- `region`: The region for resource deployment (default: `europe-west1`).

### VPC variables

- `enable_vpc`: Set to 1 to enable VPC components to be created; 0 will ignore VPC creation (default: `1`).
- `vpc_network_name`: Name of the VPC network to be created (default: `vpc-network`).
- `vpc_subnet_name`: Name of the VPC subnet to be created (default: `vpc-sub-network`).
- `vpc_subnet_ip_cidr_range`: IP CIDR range for the VPC subnet (default: `10.0.0.0/24`).
- `vpc_connector_name`: Name of the VPC connector (default: `vpc-access-connector`).
- `vpc_connector_subnet_name`: Name of the VPC connector subnet to be created (default: `vpc-connector-sub-network`).
- `vpc_connector_subnet_ip_cidr_range`: IP CIDR range for the VPC connector subnet (default: `10.100.0.0/28`).
- `vpc_connector_machine_type`: Machine type of the VPC access connector (default: `e2-micro`).

### Cloud Run Service variables

- `cloud_run_service_name`: Name of the Cloud Run service to be created (default: `cloud-run-service`).
- `cloud_run_container_concurrency`: Number of simultaneous requests that can be processed by each container (default: `30`).
- `cloud_run_timeout_seconds`: Time limit for the service to return a response, in seconds (default: `180`).
- `cloud_run_service_account`: Service account used to run the service. **(required)**
- `cloud_run_service_image_location`: Location of the image for the Cloud Run service (default: `nginx:alpine`).
- `cloud_run_cpu_request`: Requested CPU specs for the Cloud Run service (default: `1000m`).
- `cloud_run_memory_request`: Requested memory specs for the Cloud Run service (default: `1024Mi`).
- `cloud_run_cpu_limit`: CPU limit for the Cloud Run service (default: `2000m`).
- `cloud_run_memory_limit`: Memory limit for the Cloud Run service (default: `2048Mi`).
- `cloud_run_container_port`: Port on which the Cloud Run service will listen (default: `80`).
- `cloud_run_max_scale`: Maximum number of containers that can be scaled up (default: `5`).
- `cloud_run_min_scale`: Minimum number of containers that can be scaled up (default: `0`).
- `cloud_run_vpc_access_egress`: Controls outbound network access for the Cloud Run service (default: `private-ranges-only`) _⚠️ This feature will only be used when "enable_vpc" is set to "1"._
- `cloud_run_vpc_access_ingress`: Manages inbound network access for the Cloud Run service (default: `internal-and-cloud-load-balancing`).
- `cloud_run_cpu_throttling`: Degree to which the CPU usage of the Cloud Run service is limited during resource allocation (default: `true`).
- `cloud_run_session_affinity`: Degree to which requests from a client should be directed to the same container (default: `true`).
- `cloud_run_cpu_boost`: Determines whether a CPU boost should be enabled to reduce startup time (default: `true`).

## How to use this module

### Using it in a new Terraform project

1. Clone this repository from GitHub:

```bash
git clone https://github.com/RuneDD/GCP-CloudRun-VPC-Integration-Module.git
```

2. Navigate to the cloned directory and ensure you have Terraform installed:

```
cd GCP-CloudRun-VPC-Integration-Module
terraform init
```

3. Configure your variables in a `terraform.tfvars` file or pass them directly to the terraform apply command. Also, don't forget to modify the default values of the `variables.tf` file to change some of the optial variables too.

4. Apply the configuration.

5. Review the planned actions and confirm the apply command when prompted.

You now should have the Google Cloud Run service with VPC integration up and running!

### Integrating into an existing Terraform project

1. Use this code block to integrate the module in your existing Terraform project:

```hcl
module "cloud_run_vpc_integration" {
  source  = "github.com/RuneDD/GCP-CloudRun-VPC-Integration-Module"
  <OTHER_VARIABLES>
}
```

for example:

```hcl
module "cloud_run_vpc_integration" {
  source                           = "github.com/RuneDD/GCP-CloudRun-VPC-Integration-Module"
  project_id                       = var.project_id
  region                           = "europe-west1"
  vpc_network_name                 = "vpc-network"
  vpc_subnet_name                  = "vpc-sub-network"
  vpc_subnet_ip_cidr_range         = "10.0.0.0/24"
  cloud_run_service_name           = "cloud-run-service"
  cloud_run_service_account        = var.cloud_run_service_account
  cloud_run_service_image_location = "nginx:alpine"
}
```

2. Initialize and apply the changes.

## Reporting Issues

As the maintainer of this Terraform module, I highly appreciate your feedback. If you encounter any issues, I encourage you to report them. 

To create a new issue, please follow these steps:

1. Navigate to the **Issues** tab in the GitHub repository and click on the **New issue** button.
2. In the issue description, please provide as much relevant information as possible, such as:
   - Terraform version
   - Provider versions (Google, etc.)
   - A brief description of the issue
   - Step-by-step instructions to reproduce the issue
   - Relevant code and configurations
   - Error messages and screenshots
3. If possible, label your issue appropriately.
4. Finally, click **Submit new issue** to create the issue.

I will do my best to review and respond to your issue in a timely manner. 

## Contributing

Your contributions are always welcome! If you have a fix or improvement you'd like to contribute, you can create a pull request following the standard GitHub process:

1. Fork the repository and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

By contributing, you agree that your contributions will be licensed under the project's license.

## Show Your Support

If this module helped you or saved your time, you can show your appreciation by:

- Following the author on GitHub: [RuneDD](github.com/RuneDD/).
- Staring this repository.
- Sharing this module with colleagues or friends who could benefit from it.

## License

GCP-CloudRun-VPC-Integration-Module is released under the MIT License. See the associated [LICENSE](https://github.com/RuneDD/GCP-CloudRun-VPC-Integration-Module/blob/main/LICENSE) file for details.
