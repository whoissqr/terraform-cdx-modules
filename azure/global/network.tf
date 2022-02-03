terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}


resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.rg_location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-net"
  address_space       = var.address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet1" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.bastion_address_prefixes ##["10.1.1.0/24"]
  service_endpoints    = var.service_endpoints        ##["Microsoft.Sql", "Microsoft.Storage"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "${var.prefix}-subnet2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes  ##["10.1.0.0/24"]
  service_endpoints    = var.service_endpoints # ["Microsoft.Sql", "Microsoft.Storage"]
}

resource "azurerm_public_ip" "publicip" {
  name                = "${var.prefix}-publicip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastionhost" {
  name                = "AzureBastionSubnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet1.id
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}