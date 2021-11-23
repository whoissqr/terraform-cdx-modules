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
  description = "Prefix to use for objects that need to be created"
}

variable "db_name" {
  type        = string
  description = "Name of the RDS instance; if empty, then RDS instance will be created"
  default     = ""
}

variable "db_postgres_version" {
  type        = string
  description = "Postgres version of the RDS instance"
  default     = "11"
}

# NOTE: Do NOT use 'user' as the value for 'username' as it throws:
# "Error creating DB Instance: InvalidParameterValue: MasterUsername
# user cannot be used as it is a reserved word used by the engine"
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

variable "db_vpc_id" {
  type        = string
  description = "VPC Id of EKS cluster"
  default     = ""
}

variable "db_vpc_cidr_blocks" {
  type        = list(any)
  description = "CIDR Block of EKS cluster"
  default     = ["10.0.0.0/16"]
}

variable "db_private_subnets" {
  type        = list(any)
  description = "Private subnets of the RDS instance"
  default     = []
}

variable "db_public_access" {
  type        = bool
  description = "Bool to control if instance is publicly accessible"
  default     = false
}

variable "db_instance_class" {
  type        = string
  description = "Instance type of the RDS instance"
  default     = "db.t2.small"
}

variable "db_size_in_gb" {
  type        = number
  description = "Storage size in gb of the RDS instance"
  default     = 10
}

variable "db_port" {
  type        = number
  description = "Port number on which the DB accepts connections"
  default     = 5432
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
