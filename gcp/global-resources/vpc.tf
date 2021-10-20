module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 3.4"

  count                   = local.is_vpc_exist ? 0 : 1
  project_id              = var.gcp_project
  network_name            = local.network_name
  description             = "created and managed by terraform"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"

  subnets = [
    {
      subnet_name               = local.subnet_name
      subnet_ip                 = var.vpc_cidr_block
      subnet_region             = var.gcp_region
      subnet_private_access     = var.subnet_private_access
      subnet_flow_logs          = var.subnet_flow_logs
      subnet_flow_logs_interval = var.subnet_flow_logs_interval
      subnet_flow_logs_sampling = var.subnet_flow_logs_sampling
      subnet_flow_logs_metadata = var.subnet_flow_logs_metadata
    }
  ]

  secondary_ranges = {
    "${local.subnet_name}" = [
      {
        range_name    = local.pod_range_name
        ip_cidr_range = var.vpc_secondary_range_pods
      },
      {
        range_name    = local.service_range_name
        ip_cidr_range = var.vpc_secondary_range_services
      },
    ]
  }
}

resource "google_compute_router" "nat-router" {
  count       = local.is_vpc_exist ? 0 : 1
  name        = "nat-router-${local.network_name}-${var.gcp_region}"
  description = "created and managed by terraform"
  region      = var.gcp_region
  network     = module.vpc.0.network_name
}

resource "google_compute_address" "static" {
  count       = local.is_vpc_exist ? 0 : 1
  name        = "${local.network_name}-nat-ip"
  description = "created and managed by terraform"
  region      = var.gcp_region
}

resource "google_compute_router_nat" "nat-gateway" {
  count                              = local.is_vpc_exist ? 0 : 1
  name                               = "nat-gateway-${local.network_name}-${var.gcp_region}"
  router                             = google_compute_router.nat-router.0.name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.static.*.self_link
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = var.cloud_nat_logs_enabled
    filter = var.cloud_nat_logs_filter
  }
}