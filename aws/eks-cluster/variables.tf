## AWS provider configuration
variable "aws_access_key" {
  type        = string
  description = "AWS access key to create the resources"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key to create the resources"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS region to create the resources"
}

## VPC configuration
variable "vpc_id" {
  type        = string
  description = "VPC ID in which cluster has to be created"
}

variable "vpc_public_subnets" {
  type = list(any)
}

variable "vpc_private_subnets" {
  type = list(any)
}

variable "vpc_nat_public_ips" {
  type = list(any)
}

## Cluster configuration
variable "create_eks" {
  type        = bool
  description = "controls if EKS should be created"
  default     = true
}

variable "scanfarm_enabled" {
  type        = bool
  description = "Whether scanfarm resources have to be created or not; Defaults to false (BETA)"
  default     = false
}

variable "prefix" {
  type        = string
  description = "Prefix to use for objects that need to be created"
}

variable "cluster_name" {
  type        = string
  description = "Name of the existing EKS cluster; if empty, then EKS cluster will be created"
  default     = ""
}

variable "map_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  description = "Additional IAM users to add to the aws-auth configmap"
  default     = []
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version of the EKS cluster"
  default     = "1.19"
}

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  type        = map(string)
  description = "AWS Tags to add to all resources created (wherever possible)"
  default = {
    product    = "cnc"
    automation = "dns"
    managedby  = "terraform"
  }
}

variable "cluster_create_timeout" {
  type        = string
  description = "Timeout value when creating the EKS cluster."
  default     = "60m"
}

variable "deploy_autoscaler" {
  type        = bool
  description = "Flag to enable/disable the cluster-autoscaler deployment in the eks cluster"
  default     = true
}

variable "cluster_autoscaler_helm_chart_version" {
  type        = string
  description = "Version of the cluster-autoscaler helm chart "
  default     = "9.10.4"
}

variable "deploy_ingress_controller" {
  type        = bool
  description = "Flag to enable/disable the nginx-ingress-controller deployment in the eks cluster"
  default     = true
}

variable "ingress_controller_helm_chart_version" {
  type        = string
  description = "Version of the nginx-ingress-controller helm chart"
  default     = "3.35.0"
}

## Default node pool configuration
variable "default_node_pool_instance_type" {
  type        = string
  description = "Instance type of each node in a default node pool"
  default     = "c5d.2xlarge"
}

variable "default_node_pool_ami_type" {
  type        = string
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  default     = "AL2_x86_64"
}

variable "default_node_pool_disk_size" {
  type        = number
  description = "Disk size in gb for each node in a default node pool"
  default     = 50
}

variable "default_node_pool_capacity_type" {
  type        = string
  description = "Type of instance capacity to provision default node pool. Options are ON_DEMAND and SPOT"
  default     = "ON_DEMAND"
}

variable "default_node_pool_min_size" {
  type        = number
  description = "Min number of nodes in a default node pool"
  default     = 3
}

variable "default_node_pool_max_size" {
  type        = number
  description = "Max number of nodes in a default node pool"
  default     = 9
}

## Jobfarm node pool configuration
variable "jobfarm_node_pool_instance_type" {
  type        = string
  description = "Instance type of each node in a jobfarm node pool"
  default     = "c5d.2xlarge"
}

variable "jobfarm_node_pool_ami_type" {
  type        = string
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  default     = "AL2_x86_64"
}

variable "jobfarm_node_pool_disk_size" {
  type        = number
  description = "Disk size in gb for each node in a jobfarm node pool "
  default     = 100
}

variable "jobfarm_node_pool_capacity_type" {
  type        = string
  description = "Type of instance capacity to provision jobfarm node pool. Options are ON_DEMAND and SPOT"
  default     = "SPOT"
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
