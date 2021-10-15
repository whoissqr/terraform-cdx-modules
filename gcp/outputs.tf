## VPC outputs
output "vpc_network_name" {
  value = local.is_vpc_exist ? var.vpc_name : module.vpc.0.network_name
}

output "vpc_subnet_name" {
  value = local.is_vpc_exist ? var.vpc_subnet_name : module.vpc.0.subnets_names[0]
}

output "vpc_pod_range_name" {
  value = local.is_vpc_exist ? var.vpc_pod_range_name : local.pod_range_name
}

output "vpc_service_range_name" {
  value = local.is_vpc_exist ? var.vpc_service_range_name : local.service_range_name
}

output "vpc_nat_public_ip" {
  value = local.is_vpc_exist ? var.vpc_nat_public_ips : [google_compute_address.static.0.address]
}

## Cluster outputs
output "cluster_name" {
  value = local.is_gke_cluster_exist ? var.cluster_name : module.gke.0.name
}

output "cluster_region" {
  value = var.gcp_region
}

output "namespace" {
  value = local.namespace
}

## GCS outputs
output "gcs_bucket_name" {
  value = local.is_bucket_exist ? var.bucket_name : google_storage_bucket.uploads-bucket[0].name
}

output "gcs_bucket_region" {
  value = var.gcp_region
}

## CloudSQL outputs
output "db_instance_address" {
  value = local.is_cloudsql_instance_exist ? var.db_host : google_sql_database_instance.master.0.private_ip_address
}

output "db_instance_username" {
  value = local.is_cloudsql_instance_exist ? var.db_username : google_sql_user.user.0.name
}

output "db_master_password" {
  value     = local.is_cloudsql_instance_exist ? var.db_password : random_string.password.0.result
  sensitive = true
}

output "db_instance_name" {
  value = local.is_cloudsql_instance_exist ? var.db_name : google_sql_database_instance.master.0.name
}
