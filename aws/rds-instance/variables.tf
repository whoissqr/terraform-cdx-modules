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

## RDS configuration
variable "create_db_instance" {
  type        = bool
  description = "controls if RDS instance should be created"
  default     = true
}

variable "prefix" {
  type        = string
  description = "The prefix to prepend to all resources"
}

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

variable "db_vpc_id" {
  type        = string
  description = "VPC id of EKS cluster"
  default     = ""
}

variable "db_vpc_cidr_blocks" {
  type        = list(any)
  description = "VPC CIDR Block of EKS cluster"
  default     = ["10.0.0.0/16"]
}

variable "db_private_subnets" {
  type        = list(any)
  description = "Private subnets for rds instance"
  default     = []
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
