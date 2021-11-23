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

variable "scanfarm_enabled" {
  type        = bool
  description = "Whether scanfarm resources have to be created or not; Defaults to false (BETA)"
  default     = false
}

## VPC configuration
variable "prefix" {
  type        = string
  description = "Prefix to use for objects that need to be created. This must be unique"
}

variable "vpc_name" {
  type        = string
  description = "Name of the existing VPC; if empty VPC will be created"
  default     = ""
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC subnet. Default: 10.0.0.0/16"
  default     = "10.0.0.0/16"
}

variable "vpc_secondary_range_pods" {
  type        = string
  description = "Secondary subnet range in the VPC network for pods. Default: 172.16.0.0/16"
  default     = "172.16.0.0/16"
}

variable "vpc_secondary_range_services" {
  type        = string
  description = "Secondary subnet range in the VPC network for services. Default: 192.168.0.0/19"
  default     = "192.168.0.0/19"
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
  description = "subnet flow log interval"
  default     = "INTERVAL_5_SEC"
}

variable "subnet_flow_logs_sampling" {
  type        = string
  description = "subnet flow logs sampling"
  default     = "1"
}

variable "subnet_flow_logs_metadata" {
  type        = string
  description = "Subnet flow logs type"
  default     = "INCLUDE_ALL_METADATA"
}

variable "cloud_nat_logs_enabled" {
  type        = bool
  description = "Enable logging for the CloudNAT"
  default     = false
}

variable "cloud_nat_logs_filter" {
  type        = string
  description = "Log level for the CloudNAT"
  default     = "ERRORS_ONLY"
}

## GKE cluster configuration
variable "vpc_subnet_name" {
  type        = string
  description = "Existing VPC subnet name in which cluster has to be created"
  default     = ""
}

variable "vpc_pod_range_name" {
  type        = string
  description = "Existing VPC pod range name to create the cluster"
  default     = ""
}

variable "vpc_service_range_name" {
  type        = string
  description = "Existing VPC service range name to create the cluster"
  default     = ""
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "Master ipv4 cidr range to create the cluster. Default: 192.168.254.0/28"
  default     = "192.168.254.0/28"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version of the GKE cluster"
  default     = "1.19.0"
}

variable "release_channel" {
  type        = string
  description = "The release channel of this cluster. Accepted values are UNSPECIFIED, RAPID, REGULAR and STABLE. Defaults to UNSPECIFIED"
  default     = "UNSPECIFIED"
}

variable "master_authorized_networks_config" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "List of CIDR blocks which can access the Google GKE public API server endpoint. Default: open-to-all i.e 0.0.0.0/0"
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
  description = "Flag to enable preemptible nodes in a jobfarm node pool"
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
