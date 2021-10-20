## VPC outputs
output "gcp_network_name" {
  value = local.is_vpc_exist ? var.vpc_name : module.vpc.0.network_name
}

output "gcp_subnet_name" {
  value = local.is_vpc_exist ? var.vpc_subnet_name : module.vpc.0.subnets_names[0]
}

output "gcp_nat_public_ip" {
  value = local.is_vpc_exist ? "" : google_compute_address.static.0.address
}

output "gcp_network_self_link" {
  value = local.is_vpc_exist ? "" : module.vpc.0.network_self_link
}

## Cluster outputs
output "gcp_cluster_name" {
  value = module.gke.name
}

output "gcp_cluster_region" {
  value = var.gcp_region
}
