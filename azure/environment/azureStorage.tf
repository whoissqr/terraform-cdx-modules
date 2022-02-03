

resource "azurerm_storage_account" "testsa" {
  name                     = "${var.prefix}storageac"
  resource_group_name      = var.rg_name
  location                 = var.rg_location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags = {
    owner = "varri"
  }
}

resource "azurerm_storage_account_network_rules" "test" {
  resource_group_name  = var.rg_name
  storage_account_name = azurerm_storage_account.testsa.name

  default_action             = "Deny"
  ip_rules                   = var.storage_firewall_ip_rules
  virtual_network_subnet_ids = var.vnet_subnetid
  bypass                     = ["AzureServices"]
}

resource "azurerm_storage_container" "bucket" {
  name                  = "${var.prefix}-bucket"
  storage_account_name  = azurerm_storage_account.testsa.name
  container_access_type = "private"
}
