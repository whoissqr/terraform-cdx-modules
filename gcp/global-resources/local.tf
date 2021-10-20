locals {
  is_vpc_exist       = length(var.vpc_name) > 0 ? true : false
  network_name       = length(var.vpc_name) > 0 ? var.vpc_name : "${var.prefix}-vpc"
  subnet_name        = "${local.network_name}-subnet"
  pod_range_name     = "${local.network_name}-pods"
  service_range_name = "${local.network_name}-service"
}
