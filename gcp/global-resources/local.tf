locals {
  is_vpc_exist       = length(var.vpc_name) > 0 ? true : false
  network_name       = length(var.vpc_name) > 0 ? var.vpc_name : "${var.prefix}-vpc"
  subnet_name        = "${local.network_name}-subnet"
  pod_range_name     = "${local.network_name}-pods"
  service_range_name = "${local.network_name}-service"

  scanfarm_node_pools = var.scanfarm_enabled ? [{
    name               = "small-pool"
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
  }] : []

  scanfarm_node_pool_labels = var.scanfarm_enabled ? {
    "small-pool" = {
      app       = "jobfarm"
      pool-type = "small"
  } } : {}

  scanfarm_node_pool_taints = var.scanfarm_enabled ? {
    "small-pool" = var.jobfarm_node_pool_taints
  } : {}
}
