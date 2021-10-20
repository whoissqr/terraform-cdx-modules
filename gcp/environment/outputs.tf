output "namespace" {
  value = local.namespace
}

## GCS outputs
output "gcs_bucket_name" {
  value = local.is_bucket_exist ? var.bucket_name : google_storage_bucket.uploads-bucket[0].name
}

output "gcs_bucket_region" {
  value = var.bucket_region
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
