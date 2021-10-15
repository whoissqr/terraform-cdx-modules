module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version                    = "~> 17.0"
  project_id                 = var.gcp_project
  count                      = local.is_gke_cluster_exist ? 0 : 1
  name                       = "${var.prefix}-cluster"
  description                = "created and managed by terraform"
  region                     = var.gcp_region
  network                    = local.is_vpc_exist ? var.vpc_name : module.vpc.0.network_name
  subnetwork                 = local.is_vpc_exist ? var.vpc_subnet_name : module.vpc.0.subnets_names[0]
  ip_range_pods              = local.is_vpc_exist ? var.vpc_pod_range_name : local.pod_range_name
  ip_range_services          = local.is_vpc_exist ? var.vpc_service_range_name : local.service_range_name
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  enable_private_endpoint    = false
  enable_private_nodes       = true
  network_policy             = true
  kubernetes_version         = var.kubernetes_version
  cluster_resource_labels    = var.tags
  initial_node_count         = 1
  master_authorized_networks = var.master_authorized_networks_config
  firewall_inbound_ports     = ["8443", "8080"]
  create_service_account     = false
  remove_default_node_pool   = true
  maintenance_exclusions = [{
    name       = "Daily"
    start_time = "2019-01-01T09:00:00Z"
    end_time   = "2019-01-01T17:00:00Z"
  }]
  maintenance_start_time = "05:00"

  node_pools = [
    {
      name               = "app-pool"
      autoscaling        = true
      node_count         = 1
      min_count          = var.default_node_pool_min_size
      max_count          = var.default_node_pool_max_size
      image_type         = var.default_node_pool_image_type
      machine_type       = var.default_node_pool_machine_type
      disk_size_gb       = var.default_node_pool_disk_size
      disk_type          = var.default_node_pool_disk_type
      auto_repair        = true
      auto_upgrade       = false
      preemptible        = false
      enable_secure_boot = true
    },
    {
      name               = "medium-pool"
      autoscaling        = true
      node_count         = 0
      min_count          = var.jobfarm_node_pool_min_size
      max_count          = var.jobfarm_node_pool_max_size
      image_type         = var.jobfarm_node_pool_image_type
      machine_type       = var.jobfarm_node_pool_machine_type
      disk_size_gb       = var.jobfarm_node_pool_disk_size
      disk_type          = var.jobfarm_node_pool_disk_type
      auto_repair        = true
      auto_upgrade       = false
      preemptible        = var.preemptible_jobfarm_nodes
      enable_secure_boot = true
    }
  ]

  node_pools_labels = {
    "app-pool" = {
      app       = "jobfarm"
      pool-type = "app"
    },
    "medium-pool" = {
      app       = "jobfarm"
      pool-type = "medium"
    }
  }

  node_pools_taints = {
    "medium-pool" = var.jobfarm_node_pool_taints
  }
}

data "google_client_config" "provider" {}

data "google_container_cluster" "gke_cluster" {
  name     = local.is_gke_cluster_exist ? var.cluster_name : module.gke.0.name
  location = var.gcp_region
}

provider "kubernetes" {
  host                   = local.is_gke_cluster_exist ? "https://${data.google_container_cluster.gke_cluster.endpoint}" : "https://${module.gke.0.endpoint}"
  cluster_ca_certificate = local.is_gke_cluster_exist ? base64decode(data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate) : base64decode(module.gke.0.ca_certificate)
  token                  = data.google_client_config.provider.access_token
}

provider "helm" {
  kubernetes {
    host                   = local.is_gke_cluster_exist ? "https://${data.google_container_cluster.gke_cluster.endpoint}" : "https://${module.gke.0.endpoint}"
    cluster_ca_certificate = local.is_gke_cluster_exist ? base64decode(data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate) : base64decode(module.gke.0.ca_certificate)
    token                  = data.google_client_config.provider.access_token
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
