locals {
  ## VPC values
  is_vpc_exist       = length(var.vpc_name) > 0 ? true : false
  network_name       = "${var.prefix}-vpc"
  subnet_name        = "${local.network_name}-subnet"
  pod_range_name     = "${local.network_name}-pods"
  service_range_name = "${local.network_name}-service"

  ## GKE cluster values
  is_gke_cluster_exist = length(var.cluster_name) > 0 ? true : false
  namespace            = replace(lower(var.prefix), "/[^a-zA-Z0-9]/", "")

  ## Construct nginx ingress settings
  nat_ip_list = [
    for val in length(var.vpc_nat_public_ips) > 0 ? var.vpc_nat_public_ips : [google_compute_address.static.0.address] :
    format("%s/32", val)
  ]
  master_authorized_ip_list = [
    for x in var.master_authorized_networks_config :
    x.cidr_block
  ]
  ip_white_list = concat(local.master_authorized_ip_list, local.nat_ip_list, var.ingress_white_list_ip_ranges)
  keylist = [
    for val in local.ip_white_list :
    format("controller.service.loadBalancerSourceRanges[%d]", index(local.ip_white_list, val))
  ]
  valuelist = [
    for val in local.ip_white_list :
    val
  ]
  loadBalancerSourceRanges = zipmap(local.keylist, local.valuelist)
  default_ingress_options = {
    "controller.ingressClass"              = "nginx"
    "controller.service.type"              = "LoadBalancer"
    "controller.admissionWebhooks.enabled" = "false"
  }
  ingress_settings = merge(var.ingress_settings, local.loadBalancerSourceRanges, local.default_ingress_options)

  ## GCS values
  is_bucket_exist = length(var.bucket_name) > 0 ? true : false

  ## CloudSQL values
  is_cloudsql_instance_exist                = length(var.db_name) > 0 ? true : false
  db_instance_creation_delay_factor_seconds = 60
  default_database_flags = {
    "pg_stat_statements.track"     = "all"
    track_activity_query_size      = 2048
    log_min_duration_statement     = 1000
    track_io_timing                = "on"
    "pg_stat_statements.max"       = 10000
    autovacuum_vacuum_scale_factor = 0.1
    autovacuum_vacuum_cost_limit   = 2000
  }
  database_flags = merge(local.default_database_flags, var.database_flags)
}
