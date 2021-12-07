## GCP provider configuration
variable "gcp_project" {
  type        = string
  description = "GCP project id to create the resources"
}

variable "gcp_region" {
  type        = string
  description = "GCP region to create the resources"
}

variable "tags" {
  type        = map(string)
  description = "GCP Tags to add to all resources created (wherever possible)"
  default = {
    product    = "cnc"
    automation = "dns"
    managedby  = "terraform"
  }
}

variable "scanfarm_enabled" {
  type        = bool
  description = "Whether scanfarm resources have to be created or not; Defaults to false (BETA)"
  default     = false
}

variable "prefix" {
  type        = string
  description = "Prefix to use for objects that need to be created. This must be unique"
}

variable "gcp_network_self_link" {
  type        = string
  description = "Name of the existing VPC network self link. Format looks like: https://www.googleapis.com/compute/v1/projects/{gcp_project}/global/networks/{vpc_name}"
}

variable "gcp_cluster_name" {
  type        = string
  description = "Name of the existing GKE cluster to deploy ingress / create secrets"
}

## GCS Bucket configuration
variable "bucket_name" {
  type        = string
  description = "Name of the gcs bucket; if empty, then gcs bucket will be created"
  default     = ""
}

variable "bucket_region" {
  type        = string
  description = "Region of the gcs bucket"
  default     = "US"
}

variable "expire_after" {
  type        = string
  description = "No.of days for expiration of gcs objects"
  default     = "30"
}

## CloudSQL configuration
variable "db_name" {
  type        = string
  description = "Name of the CloudSQL instance; if empty, then CloudSQL instance will be created"
  default     = ""
}

# note that google requires a custom db instance for postgres... thus the config below: https://github.com/hashicorp/terraform/issues/12617#issuecomment-298617855
variable "db_tier" {
  type        = string
  description = "The machine type to use for CloudSQL instance"
  default     = "db-custom-2-4096"
}

variable "db_version" {
  type        = string
  description = "Postgres database version"
  default     = "POSTGRES_11"
}

variable "db_availability" {
  type        = string
  description = "The availability type of the CloudSQL instance"
  default     = "ZONAL"
}

variable "db_size_in_gb" {
  type        = number
  description = "Storage size in gb of the CloudSQL instance"
  default     = 10
}

variable "database_flags" {
  type        = map(any)
  description = "database_flags for CloudSQL instance"
  default     = {}
}

variable "db_username" {
  type        = string
  description = "Username for the master DB user. Note: Do NOT use 'user' as the value"
  default     = "postgres"
}

variable "db_password" {
  type        = string
  description = "Password for the master DB user; If empty, then random password will be set by default. Note: This will be stored in the state file"
  default     = ""
}

variable "db_ipv4_enabled" {
  type        = bool
  description = "Whether this Cloud SQL instance should be assigned a public IPV4 address. Either ipv4_enabled must be enabled or a private_network must be configured."
  default     = false
}

variable "db_require_ssl" {
  type        = bool
  description = "Whether SSL connections over IP are enforced or not;"
  default     = false
}

variable "maintenance_window_day" {
  type        = number
  description = "The maintenance window is specified in UTC time"
  default     = 7
}

variable "maintenance_window_hour" {
  type        = number
  description = "The maintenance window is specified in UTC time"
  default     = 9
}

## Ingress configuration
variable "deploy_ingress_controller" {
  type        = bool
  description = "Flag to enable/disable the nginx-ingress-controller deployment in the GKE cluster"
  default     = true
}

variable "ingress_namespace" {
  type        = string
  description = "Namespace in which ingress controller should be deployed. If empty, then ingress-controller will be created"
  default     = ""
}

variable "ingress_controller_helm_chart_version" {
  type        = string
  description = "Version of the nginx-ingress-controller helm chart"
  default     = "3.35.0"
}

variable "ingress_white_list_ip_ranges" {
  type        = list(string)
  description = "List of source ip ranges for load balancer whitelisting; we recommend you to pass the list of your organization source IPs. Note: You must add NAT IP of your existing VPC or `gcp_nat_public_ip` output value from global module to this list"
  default     = ["0.0.0.0/0"]
}

variable "ingress_settings" {
  type        = map(string)
  description = "Additional settings which will be passed to the Helm chart values, see https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx"
  default     = {}
}

## Secrets configuration
variable "app_namespace" {
  type        = string
  description = "Namespace of existing cluster in which secrets can be created; if empty, then namespace will be created with prefix value"
  default     = ""
}

# variable "create_db_secret" {
#   type        = bool
#   description = "Flag to enable/disable the 'cnc-db-credentials' secret creation in the eks cluster"
#   default     = true
# }

# variable "create_gcs_secret" {
#   type        = bool
#   description = "Flag to enable/disable the 'cnc-gcs-credentials' secret creation in the gke cluster"
#   default     = true
# }

# variable "db_host" {
#   type        = string
#   description = "Host addr of the CloudSQL instance"
#   default     = ""
# }

# variable "db_port" {
#   type        = number
#   description = "Port number of CloudSQL instance"
#   default     = 5432
# }
