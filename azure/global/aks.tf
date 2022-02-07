
locals {
  random_prefix = "${var.prefix}-${random_id.tf-k8s-acc.hex}"
}




# Configure the Microsoft Azure Provider


data "azurerm_kubernetes_service_versions" "current" {
  location       = var.rg_location
  version_prefix = var.kubernetes_version
}

resource "random_id" "tf-k8s-acc" {
  byte_length = 3
}

resource "azurerm_kubernetes_cluster" "tf-k8s-acc" {
  name                = "${var.prefix}-cluster"
  resource_group_name = var.rg_name
  location            = var.rg_location
  dns_prefix          = "${local.random_prefix}-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  api_server_authorized_ip_ranges = var.cluster_endpoint_public_access_cidrs

  
   default_node_pool{
    name               = var.default_node_pool_name    
    vm_size            = var.default_node_pool_vm_size 
    type               = "VirtualMachineScaleSets"
    node_count         = var.node_count
    availability_zones = var.availability_zones  
    max_pods           = var.max_pods_count 
    
    os_disk_type       = var.default_node_pool_os_disk_type 
    os_disk_size_gb    = var.os_disk_size_gb 
    max_count = var.default_node_pool_max_node_count   
    min_count = var.default_node_pool_min_node_count  
    
    enable_auto_scaling = true  
    vnet_subnet_id = azurerm_subnet.subnet2.id
    
  }

  identity {
    type =  var.identity_type 
  }

  role_based_access_control {
    enabled = true
  }

  network_profile {
    network_plugin =  var.network_plugin  
    load_balancer_sku = var.load_balancer_sku 
  }
  addon_profile {
    http_application_routing{
      enabled = true
    }
  }

  
}

resource "azurerm_kubernetes_cluster_node_pool" "custompool" {
  name                  = var.custom_pool_name   
  kubernetes_cluster_id = azurerm_kubernetes_cluster.tf-k8s-acc.id
  vm_size               = var.custompool_vm_size   
  node_count            = 1
  os_type               = "Linux"
  os_disk_type          = var.custompool_os_disk_type 
  mode                = "User"
  node_taints = var.node_taints 
  min_count = var.custompool_min_count
  max_count = var.custompool_max_count
  availability_zones = var.availability_zones 
  enable_auto_scaling = var.enable_auto_scaling
  node_labels =  var.node_labels 
  
}


provider "helm" {
    kubernetes {
        host     = azurerm_kubernetes_cluster.tf-k8s-acc.kube_config.0.host
        client_key             = base64decode(azurerm_kubernetes_cluster.tf-k8s-acc.kube_config.0.client_key)
        client_certificate     = base64decode(azurerm_kubernetes_cluster.tf-k8s-acc.kube_config.0.client_certificate)
        cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.tf-k8s-acc.kube_config.0.cluster_ca_certificate)
    }  
}

resource "helm_release" "ingress" {
  count            = var.deploy_ingress_controller ? 1 : 0
  name             = "ingress-nginx"
  create_namespace = true
  namespace        = length(var.ingress_namespace) > 0 ? var.ingress_namespace : "ingress-controller"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.ingress_controller_helm_chart_version

  dynamic "set" {
    for_each = local.ingress_settings
    content {
      name  = set.key
      value = set.value
    }
  }
}



