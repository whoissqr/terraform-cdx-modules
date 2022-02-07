output "rg_name" {
  value = resource.azurerm_resource_group.rg.name
}
output "rg_location" {
  value = resource.azurerm_resource_group.rg.location
}
output "vnet_name" {
  value = resource.azurerm_virtual_network.vnet.name
}

output "subnetid" {
  value = resource.azurerm_subnet.subnet2.id
}

output "publicip" {
  value = resource.azurerm_public_ip.publicip.ip_address
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.tf-k8s-acc.name
}