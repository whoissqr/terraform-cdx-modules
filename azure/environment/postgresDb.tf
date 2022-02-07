terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.90.0"
    }
  }
}


# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}





resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = "${var.prefix}psqlserver"
  resource_group_name    = var.rg_name
  location               = var.rg_location
  version                = var.postgresql_version
  administrator_login    = var.db_username
  administrator_password = var.db_password
  storage_mb             = 32768
  sku_name               = "GP_Standard_D4s_v3"

}


resource "azurerm_postgresql_flexible_server_configuration" "serverconfig" {
  name      = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.postgres.id
  value     = "off"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "postgresqlfwrule" {
  name                = "Postgrescnc"
  server_id         = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
