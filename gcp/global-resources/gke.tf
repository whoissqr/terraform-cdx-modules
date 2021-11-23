module "gke" {
  source                            = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version                           = "~> 17.0"
  project_id                        = var.gcp_project
  name                              = "${var.prefix}-cluster"
  description                       = "created and managed by terraform"
  region                            = var.gcp_region
  network                           = local.is_vpc_exist ? var.vpc_name : module.vpc.0.network_name
  subnetwork                        = local.is_vpc_exist ? var.vpc_subnet_name : module.vpc.0.subnets_names[0]
  ip_range_pods                     = local.is_vpc_exist ? var.vpc_pod_range_name : local.pod_range_name
  ip_range_services                 = local.is_vpc_exist ? var.vpc_service_range_name : local.service_range_name
  master_ipv4_cidr_block            = var.master_ipv4_cidr_block
  enable_private_endpoint           = false
  enable_private_nodes              = true
  network_policy                    = true
  kubernetes_version                = var.kubernetes_version
  release_channel                   = var.release_channel
  cluster_resource_labels           = var.tags
  initial_node_count                = 1
  master_authorized_networks        = var.master_authorized_networks_config
  add_master_webhook_firewall_rules = true
  firewall_inbound_ports            = ["8443", "443"]
  create_service_account            = false
  remove_default_node_pool          = true
  node_metadata                     = "UNSPECIFIED"
  maintenance_exclusions = [{
    name       = "Daily"
    start_time = "2019-01-01T09:00:00Z"
    end_time   = "2019-01-01T17:00:00Z"
  }]
  maintenance_start_time = "05:00"

  node_pools = concat([
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
    }], local.scanfarm_node_pools
  )

  node_pools_labels = merge(
    {
      "app-pool" = {
        app       = "jobfarm"
        pool-type = "app"
      }
    }, local.scanfarm_node_pool_labels
  )

  node_pools_taints = local.scanfarm_node_pool_taints
}
