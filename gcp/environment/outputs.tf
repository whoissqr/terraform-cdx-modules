# output "namespace" {
#   value = local.namespace
# }

## GCS outputs
output "gcs_bucket_name" {
  value = var.scanfarm_enabled ? google_storage_bucket.uploads-bucket[0].name : null
}

output "gcs_bucket_region" {
  value = var.scanfarm_enabled ? var.bucket_region : null
}

output "gcs_service_account" {
  value     = var.scanfarm_enabled ? base64decode(google_service_account_key.gcs_sa_key.0.private_key) : null
  sensitive = true
}

## CloudSQL outputs
output "db_instance_address" {
  value = !local.is_cloudsql_instance_exist ? google_sql_database_instance.master.0.private_ip_address : null
}

output "db_instance_username" {
  value = !local.is_cloudsql_instance_exist ? google_sql_user.user.0.name : null
}

output "db_master_password" {
  value     = !local.is_cloudsql_instance_exist ? length(var.db_password) > 0 ? var.db_password : random_string.password.0.result : null
  sensitive = true
}

output "db_instance_name" {
  value = !local.is_cloudsql_instance_exist ? google_sql_database_instance.master.0.name : null
}
