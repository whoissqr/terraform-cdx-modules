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
variable "create_vpc" {
  type        = bool
  description = "controls if VPC should be created"
  default     = true
}

variable "prefix" {
  type        = string
  description = "Prefix to use for objects that need to be created"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_id" {
  type        = string
  description = "ID of the existing VPC"
  default     = ""
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
