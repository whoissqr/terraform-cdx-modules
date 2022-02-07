variable "prefix" {
  description = "A prefix used for all resources in this example"
}

variable "rg_location" {
  default     = "West Europe"
  description = "The Azure Region in which all resources in this example should be provisioned"
}

variable "subscription_id" {
  type = string
  description = "azure account subscription id"
}

variable "rg_name" {
  description = "name of the azure resource group"
}

variable "db_username" {
  type        = string
  description = "Username for the master DB user. Note: Do NOT use 'user' as the value"
  default     = "psqladmin"
}

variable "db_password" {
  type        = string
  description = "Password for the master DB user; If empty, then random password will be set by default. Note: This will be stored in the state file"
  default     = "Synopsys@123"
}

variable "postgresql_version" {
  type        = string
  description = "postgresql DB version"
  default     = "12"
}


variable "vnet_subnetid" {
  type        = list(string)
  description = "subnet id to attach with the storage account"
  default     = []
}

variable "storage_firewall_ip_rules" {
  type    = list(string)
  default = ["0.0.0.0/0"]

}