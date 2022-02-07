output "fqdn" {
  value = resource.azurerm_postgresql_flexible_server.postgres.fqdn
}

output "postgres_server_id" {
  value = resource.azurerm_postgresql_flexible_server.postgres.id
}

output "storageaccount_name" {
  value = resource.azurerm_storage_account.testsa.name
}

output "db_login" {
  sensitive = true
  value     = resource.azurerm_postgresql_flexible_server.postgres.administrator_login
}

output "db_password" {
  sensitive = true
  value     = resource.azurerm_postgresql_flexible_server.postgres.administrator_password
}

output "bucket" {
  value = resource.azurerm_storage_container.bucket.name
}

output "storage_access_key" {
  value     = resource.azurerm_storage_account.testsa.primary_access_key
  sensitive = true
}
