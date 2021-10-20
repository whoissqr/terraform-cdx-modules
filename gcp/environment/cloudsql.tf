resource "random_string" "instanceid" {
  count   = local.is_cloudsql_instance_exist ? 0 : 1
  length  = 6
  lower   = true
  upper   = false
  special = false
}

data "google_compute_zones" "available" {
  count  = local.is_cloudsql_instance_exist ? 0 : 1
  region = var.gcp_region
}

resource "google_compute_global_address" "private_ip_address" {
  count         = local.is_cloudsql_instance_exist ? 0 : 1
  provider      = google-beta
  name          = "private-ip-address-db-${local.namespace}"
  project       = var.gcp_project
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = var.gcp_network_self_link
  labels        = var.tags
}

resource "google_service_networking_connection" "private_vpc_connection" {
  depends_on              = [google_compute_global_address.private_ip_address]
  count                   = local.is_cloudsql_instance_exist ? 0 : 1
  provider                = google-beta
  network                 = var.gcp_network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.0.name]
}

resource "null_resource" "cloudsql_network_delay" {
  depends_on = [google_service_networking_connection.private_vpc_connection]
  count      = local.is_cloudsql_instance_exist ? 0 : 1

  provisioner "local-exec" {
    command = "echo Gradual DB instance creation && sleep ${local.db_instance_creation_delay_factor_seconds}"
  }
}

resource "google_sql_database_instance" "master" {
  depends_on          = [null_resource.cloudsql_network_delay]
  count               = local.is_cloudsql_instance_exist ? 0 : 1
  provider            = google-beta
  name                = "${local.namespace}-${random_string.instanceid.0.result}"
  database_version    = var.db_version
  region              = var.gcp_region
  project             = var.gcp_project
  deletion_protection = false

  settings {
    location_preference {
      zone = data.google_compute_zones.available.0.names[0]
    }
    tier              = var.db_tier
    availability_type = var.db_availability
    maintenance_window {
      day  = var.maintenance_window_day
      hour = var.maintenance_window_hour
    }
    ip_configuration {
      ipv4_enabled    = var.db_ipv4_enabled
      require_ssl     = var.db_require_ssl
      private_network = var.gcp_network_self_link
    }

    dynamic "database_flags" {
      iterator = flag
      for_each = local.database_flags
      content {
        name  = flag.key
        value = flag.value
      }
    }
    user_labels = var.tags
  }
}

resource "random_string" "password" {
  count   = !local.is_cloudsql_instance_exist && length(var.db_password) == 0 ? 1 : 0
  length  = 16
  special = false
}

resource "google_sql_user" "user" {
  depends_on = [google_sql_database_instance.master.0]
  count      = local.is_cloudsql_instance_exist ? 0 : 1
  name       = var.db_username
  instance   = google_sql_database_instance.master.0.name
  password   = length(var.db_password) > 0 ? var.db_password : random_string.password.0.result
  project    = var.gcp_project
}
