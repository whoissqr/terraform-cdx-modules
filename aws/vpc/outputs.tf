output "vpc_id" {
  value = local.is_vpc_exist ? var.vpc_id : module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = local.is_vpc_exist ? data.aws_vpc.default.0.cidr_block : module.vpc.vpc_cidr_block
}

output "vpc_public_subnets" {
  value = local.is_vpc_exist ? [for s in data.aws_subnet.default : s.id if replace(s.tags.Name, "public", "") != s.tags.Name] : module.vpc.public_subnets
}

output "vpc_private_subnets" {
  value = local.is_vpc_exist ? [for s in data.aws_subnet.default : s.id if replace(s.tags.Name, "private", "") != s.tags.Name] : module.vpc.private_subnets
}

output "vpc_nat_public_ips" {
  value = local.is_vpc_exist ? [data.aws_nat_gateway.default.0.public_ip] : module.vpc.nat_public_ips
}
