## GCP provider configuration
variable "gcp_project" {
  type        = string
  description = "GCP project id to create the resources"
}

variable "gcp_region" {
  type        = string
  description = "GCP region to create the resources"
}

## Common configuration
variable "tags" {
  type        = map(string)
  description = "GCP Tags to add to all resources created (wherever possible)"
  default = {
    product    = "cnc"
    automation = "dns"
    managedby  = "terraform"
  }
}

## VPC configuration
variable "prefix" {
  type        = string
  description = "Prefix to use for objects that need to be created"
}

variable "vpc_name" {
  type        = string
  description = "Name of the existing VPC"
  default     = ""
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC subnet"
  default     = "10.0.0.0/16"
}

variable "vpc_secondary_range_pods" {
  type        = string
  description = "Secondary subnet range in the VPC network for pods"
  default     = "172.16.0.0/16"
}

variable "vpc_secondary_range_services" {
  type        = string
  description = "Secondary subnet range in the VPC network for services"
  default     = "192.168.0.0/19"
}

variable "cloudsql_ip_address" {
  type        = string
  description = "IP range in the VPC network for CloudSQL"
  default     = "10.2.255.0"
}

variable "subnet_private_access" {
  type        = bool
  description = "Enable private access for the subnet"
  default     = true
}

variable "subnet_flow_logs" {
  type        = bool
  description = "Enable vpc flow logs for the subnet"
  default     = false
}

variable "subnet_flow_logs_interval" {
  type        = string
  description = "flow log interval"
  default     = "INTERVAL_5_SEC"
}

variable "subnet_flow_logs_sampling" {
  type        = string
  description = "subnet_flow_logs_sampling"
  default     = "1"
}

variable "subnet_flow_logs_metadata" {
  type        = string
  description = "Flow logs type"
  default     = "INCLUDE_ALL_METADATA"
}

variable "cloud_nat_logs_enabled" {
  type        = bool
  description = "Enable logging for the CloudNat"
  default     = false
}

variable "cloud_nat_logs_filter" {
  type        = string
  description = "Log level for the CloudNat"
  default     = "ERRORS_ONLY"
}

## GKE cluster configuration
variable "cluster_name" {
  type        = string
  description = "Name of the existing GKE cluster; if empty, then GKE cluster will be created"
  default     = ""
}

variable "vpc_subnet_name" {
  type        = string
  description = "VPC subnet name in which cluster has to be created"
  default     = ""
}

variable "vpc_pod_range_name" {
  type        = string
  description = "VPC pod range name to create the cluster"
  default     = ""
}

variable "vpc_service_range_name" {
  type        = string
  description = "VPC service range name to create the cluster"
  default     = ""
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "Master ipv4 cidr range to create the cluster"
  default     = "192.168.254.0/28"
}

variable "vpc_nat_public_ips" {
  type        = list(string)
  description = "List of NAT ips to whitelist in nginx ingress controller"
  default     = []
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version of the GKE cluster"
  default     = "1.19.14-gke.301"
}

variable "master_authorized_networks_config" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "List of CIDR blocks which can access the Google GKE public API server endpoint"
  default = [
    {
      display_name = "open-to-all"
      cidr_block   = "0.0.0.0/0"
    }
  ]
}

## Default node pool configuration
variable "default_node_pool_machine_type" {
  type        = string
  description = "Machine type of each node in a default node pool"
  default     = "n1-standard-8"
}

variable "default_node_pool_image_type" {
  type        = string
  description = "Image type of each node in a default node pool"
  default     = "COS_CONTAINERD"
}

variable "default_node_pool_disk_size" {
  type        = number
  description = "Disk size in gb for each node in a default node pool"
  default     = 50
}

variable "default_node_pool_disk_type" {
  type        = string
  description = "Disk type of each node in a default node pool. Options are pd-standard and pd-ssd"
  default     = "pd-ssd"
}

variable "default_node_pool_min_size" {
  type        = number
  description = "Min number of nodes in a default node pool"
  default     = 1
}

variable "default_node_pool_max_size" {
  type        = number
  description = "Max number of nodes in a default node pool"
  default     = 5
}

## Jobfarm node pool configuration
variable "jobfarm_node_pool_machine_type" {
  type        = string
  description = "Machine type of each node in a jobfarm node pool"
  default     = "c2-standard-8"
}

variable "jobfarm_node_pool_image_type" {
  type        = string
  description = "Image type to each node in a jobfarm node pool"
  default     = "COS_CONTAINERD"
}

variable "jobfarm_node_pool_disk_size" {
  type        = number
  description = "Disk size in gb for each node in a jobfarm node pool "
  default     = 100
}

variable "jobfarm_node_pool_disk_type" {
  type        = string
  description = "Disk type of each node in a jobfarm node pool. Options are pd-standard and pd-ssd"
  default     = "pd-ssd"
}

variable "jobfarm_node_pool_min_size" {
  type        = number
  description = "Min number of nodes in a jobfarm node pool"
  default     = 0
}

variable "jobfarm_node_pool_max_size" {
  type        = number
  description = "Max number of nodes in a jobfarm node pool"
  default     = 50
}

variable "preemptible_jobfarm_nodes" {
  type        = bool
  description = "Enable preemptible nodes in a jobfarm node pool"
  default     = false
}

variable "jobfarm_node_pool_taints" {
  type        = list(any)
  description = "Taints for the jobfarm node pool"
  default = [
    {
      key    = "NodeType"
      value  = "ScannerNode"
      effect = "NO_SCHEDULE"
    }
  ]
}

## GCS Bucket configuration
variable "bucket_name" {
  type        = string
  description = "Name of the gcs bucket; if empty, then gcs bucket will be created"
  default     = ""
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
  default     = "POSTGRES_9_6"
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
  description = "Whether SSL connections over IP are enforced or not."
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

variable "db_port" {
  type        = number
  description = "The port number of CloudSQL instance"
  default     = 5432
}

## Ingress configuration
variable "ingress_namespace" {
  type        = string
  description = "Namespace in which ingress controller should be deployed. If empty, then ingress-controller will be created"
  default     = ""
}

variable "deploy_ingress_controller" {
  type        = bool
  description = "Flag to enable/disable the nginx-ingress-controller deployment in the GKE cluster"
  default     = true
}

variable "ingress_controller_helm_chart_version" {
  type        = string
  description = "Version of the nginx-ingress-controller helm chart"
  default     = "3.35.0"
}

variable "ingress_white_list_ip_ranges" {
  type        = list(any)
  description = "List of source ip ranges for load balancer whitelisting."
  default     = []
}

variable "ingress_settings" {
  type        = map(string)
  description = "Additional settings which will be passed to the Helm chart values, see https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx"
  default     = {}
}

## Secrets configuration
variable "create_db_secret" {
  type        = bool
  description = "Flag to enable/disable the 'cnc-db-credentials' secret creation in the eks cluster"
  default     = true
}

variable "create_gcs_secret" {
  type        = bool
  description = "Flag to enable/disable the 'cnc-gcs-credentials' secret creation in the gke cluster"
  default     = true
}

variable "db_host" {
  type        = string
  description = "Host of the CloudSQL instance"
  default     = ""
}
