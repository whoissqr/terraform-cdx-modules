locals {
  namespace = length(var.app_namespace) > 0 ? var.app_namespace : replace(lower(var.prefix), "/[^a-zA-Z0-9]/", "")

  ## Construct nginx ingress settings
  keylist = [
    for val in var.ingress_white_list_ip_ranges :
    format("controller.service.loadBalancerSourceRanges[%d]", index(var.ingress_white_list_ip_ranges, val))
  ]
  valuelist = [
    for val in var.ingress_white_list_ip_ranges :
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
