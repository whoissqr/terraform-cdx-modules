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

## S3 configuration
variable "create_bucket" {
  type        = bool
  description = "controls if s3 bucket should be created"
  default     = true
}

variable "prefix" {
  type        = string
  description = "Prefix to use for objects that need to be created"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket; if empty, then S3 bucket will be created"
  default     = ""
}

variable "expire_after" {
  type        = string
  description = "No.of days for expiration of S3 objects"
  default     = "30"
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
