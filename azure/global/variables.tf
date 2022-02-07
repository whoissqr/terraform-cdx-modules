variable "prefix" {
  description = "A prefix used for all resources in this example"
}




variable "subscription_id" {
  type    = string

}
####################### VNET ########################

variable "address_space" {
  type    = list(string)
  default = ["10.1.0.0/16"]

}

variable "bastion_address_prefixes" {
  type    = list(string)
  default = ["10.1.1.0/24"]
}

variable "service_endpoints" {
  type    = list(string)
  default = ["Microsoft.Sql", "Microsoft.Storage"]
}

variable "address_prefixes" {
  type    = list(string)
  default = ["10.1.0.0/24"]
}


#############################  CLUSTER #################

variable "kubernetes_version" {
  type    = string
  default = "1.20.9"
}

variable "workers_count" {
  type    = string
  default = 2
}

variable "workers_type" {
  type    = string
  default = "Standard_DS4_v2"
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Azure AKS public API server endpoint."
  type        = list(string)
  default = ["0.0.0.0/0"]
}


variable "rg_name" {
  type = string
}

variable "rg_location" {
  type    = string
  default = "West Europe"
}


############ default node pool 

variable "default_node_pool_name" {
  type    = string
  default = "agentpool"
}

variable "default_node_pool_vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "node_count" {
  type    = number
  default = 1
}

variable "availability_zones" {
  type    = list(string)
  default = ["1", "2"]
}

variable "max_pods_count" {
  type    = number
  default = 80
}

variable "default_node_pool_os_disk_type" {
  type    = string
  default = "Managed"
}

variable "os_disk_size_gb" {
  type    = number
  default = 128
}

variable "default_node_pool_max_node_count" {
  type    = number
  default = 5
}

variable "default_node_pool_min_node_count" {
  type    = number
  default = 1
}


variable "identity_type" {
  type    = string
  default = "SystemAssigned"
}

variable "network_plugin" {
  type    = string
  default = "kubenet"
}

variable "load_balancer_sku" {
  type    = string
  default = "standard"
}

################# custom pool 

variable "custom_pool_name" {
  type    = string
  default = "small"
}

variable "custompool_vm_size" {
  type    = string
  default = "Standard_D8as_v4"
}

variable "node_taints" {
  type    = list(string)
  default = ["NodeType=ScannerNode:NoSchedule"]
}

variable "custompool_os_disk_type" {
  type    = string
  default = "Ephemeral"
}

variable "enable_auto_scaling" {
  type    = bool
  default = true
}

variable "node_labels" {
  type = map(string)
  default = {
    "app" : "jobfarm",
    "pool-type" : "small"
  }

}

variable "custompool_min_count" {
  type    = number
  default = 1

}

variable "custompool_max_count" {
  type    = number
  default = 5

}

############# ingress 

variable "ingress_white_list_ip_ranges" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "deploy_ingress_controller" {
  type        = bool
  description = "Flag to enable/disable the nginx-ingress-controller deployment in the GKE cluster"
  default     = true
}

variable "ingress_controller_helm_chart_version" {
  type        = string
  description = "Version of the nginx-ingress-controller helm chart"
  default     = "3.35.0"
}

variable "ingress_settings" {
  type        = map(string)
  description = "Additional settings which will be passed to the Helm chart values, see https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx"
  default     = {}
}

variable "ingress_namespace" {
  type        = string
  description = "Namespace in which ingress controller should be deployed. If empty, then ingress-controller will be created"
  default     = ""
}
