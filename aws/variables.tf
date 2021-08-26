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

## Common configuration
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

variable "prefix" {
  type        = string
  description = "The prefix to prepend to all resources"
}

## VPC configuration
variable "vpc_id" {
  type        = string
  description = "ID of the existing VPC"
  default     = ""
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

## EKS cluster configuration
variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = ""
}

variable "map_users" {
  type        = list(any)
  description = "Users details to add in aws-auth config map"
  default     = []
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

## S3 configuration
variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
  default     = ""
}

variable "expire_after" {
  type        = string
  description = "No.of days for expiration of S3 objects"
  default     = "30"
}

## RDS configuration
variable "db_name" {
  type        = string
  description = "Name of the RDS instance"
  default     = ""
}

variable "db_postgres_version" {
  type        = string
  description = "Postgres version for rds instance"
  default     = "9.6"
}

# NOTE: Do NOT use 'user' as the value for 'username' as it throws:
# "Error creating DB Instance: InvalidParameterValue: MasterUsername
# user cannot be used as it is a reserved word used by the engine"
variable "db_username" {
  type        = string
  description = "Username for rds instance"
  default     = "postgres"
}

variable "db_password" {
  type        = string
  description = "Password for rds instance"
  default     = ""
}

variable "db_public_access" {
  type        = bool
  description = "Public access (enable/disable) flag for rds instance"
  default     = false
}

variable "db_instance_class" {
  type        = string
  description = "Instance class for rds instance"
  default     = "db.t2.small"
}

variable "db_size_in_gb" {
  type        = number
  description = "Storage size in gb for rds instance"
  default     = 10
}

variable "db_port" {
  type        = number
  description = "Port for rds instance"
  default     = 5432
}

# Secrets configuration
variable "create_db_secret" {
  type        = bool
  description = "controls if db secret should be created"
  default     = true
}

variable "create_s3_secret" {
  type        = bool
  description = "controls if s3 secret should be created"
  default     = true
}
