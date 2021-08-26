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

# Secrets configuration
variable "prefix" {
  type        = string
  description = "Prefix to use for objects that need to be created"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "create_db_secret" {
  type        = bool
  description = "Flag to enable/disable the 'cnc-db-credentials' secret creation in the eks cluster"
  default     = true
}

variable "db_host" {
  type        = string
  description = "Host of the RDS instance"
}

variable "db_port" {
  type        = number
  description = "Port of the RDS instance"
}

variable "db_username" {
  type        = string
  description = "Username of the RDS instance"
}

variable "db_password" {
  type        = string
  description = "Password of the RDS instance"
}

variable "create_s3_secret" {
  type        = bool
  description = "Flag to enable/disable the 'cnc-s3-credentials' secret creation in the eks cluster"
  default     = true
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "bucket_region" {
  type        = string
  description = "Region of the S3 bucket"
}
