## VPC outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_public_subnets" {
  value = module.vpc.vpc_public_subnets
}

output "vpc_private_subnets" {
  value = module.vpc.vpc_private_subnets
}

output "vpc_nat_public_ips" {
  value = module.vpc.vpc_nat_public_ips
}

## Cluster outputs
output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "cluster_region" {
  value = var.aws_region
}

## S3 outputs
output "s3_bucket_name" {
  value = module.s3_bucket.s3_bucket_name
}

output "s3_bucket_region" {
  value = module.s3_bucket.s3_bucket_region
}

## RDS outputs
output "db_instance_address" {
  value = module.rds_instance.db_instance_address
}

output "db_instance_port" {
  value = module.rds_instance.db_instance_port
}

output "db_instance_username" {
  value     = module.rds_instance.db_instance_username
  sensitive = true
}

output "db_master_password" {
  value     = module.rds_instance.db_master_password
  sensitive = true
}

output "db_instance_name" {
  value = module.rds_instance.db_instance_name
}

output "db_subnet_group_id" {
  value = module.rds_instance.db_subnet_group_id
}

# output "namespace" {
#   value = replace(lower(var.prefix), "/[^a-zA-Z0-9]/", "")
# }
