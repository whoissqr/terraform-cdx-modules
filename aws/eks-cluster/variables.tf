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

variable "prefix" {
  type        = string
  description = "The prefix to prepend to all resources"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = ""
}

variable "map_users" {
  type        = list(any)
  description = "Users details to add in aws-auth config map"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version of the EKS cluster"
  default     = "1.19"
}

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(any)
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  type        = map(string)
  description = "Tags and labels for cloud resources"
  default = {
    product    = "cnc"
    stack      = "dev"
    automation = "dns"
    managedby  = "terraform"
  }
}

variable "instance_create_timeout" {
  type    = string
  default = "60m"
}

variable "deploy_autoscaler" {
  type    = bool
  default = true
}

variable "cluster_autoscaler_helm_chart_version" {
  type    = string
  default = "9.10.4"
}

variable "deploy_ingress_controller" {
  type    = bool
  default = true
}

variable "ingress_controller_helm_chart_version" {
  type    = string
  default = "3.35.0"
}

## Default node pool configuration
variable "default_node_pool_instance_type" {
  type    = string
  default = "c5d.2xlarge"
}

variable "default_node_pool_ami_type" {
  type    = string
  default = "AL2_x86_64"
}

variable "default_node_pool_disk_size" {
  type    = number
  default = 50
}

variable "default_node_pool_capacity_type" {
  type    = string
  default = "ON_DEMAND"
}

variable "default_node_pool_min_size" {
  type    = number
  default = 3
}

variable "default_node_pool_max_size" {
  type    = number
  default = 9
}

## Jobfarm node pool configuration
variable "jobfarm_node_pool_disk_size" {
  type    = number
  default = 100
}

variable "jobfarm_node_pool_capacity_type" {
  type    = string
  default = "SPOT"
}

variable "jobfarm_node_pool_min_size" {
  type    = number
  default = 0
}

variable "jobfarm_node_pool_max_size" {
  type    = number
  default = 50
}

variable "jobfarm_node_pool_taints" {
  type = list(any)
  default = [
    {
      key    = "NodeType"
      value  = "ScannerNode"
      effect = "NO_SCHEDULE"
    }
  ]
}
