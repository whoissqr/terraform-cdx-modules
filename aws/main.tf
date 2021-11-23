module "vpc" {
  source         = "./vpc"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  aws_region     = var.aws_region
  create_vpc     = length(var.vpc_id) > 0 ? false : true
  prefix         = var.prefix
  vpc_id         = var.vpc_id
  vpc_cidr_block = var.vpc_cidr_block
  tags           = var.tags
}

module "eks_cluster" {
  source                                = "./eks-cluster"
  aws_access_key                        = var.aws_access_key
  aws_secret_key                        = var.aws_secret_key
  aws_region                            = var.aws_region
  create_eks                            = length(var.cluster_name) > 0 ? false : true
  scanfarm_enabled                      = var.scanfarm_enabled
  prefix                                = var.prefix
  vpc_id                                = module.vpc.vpc_id
  vpc_public_subnets                    = module.vpc.vpc_public_subnets
  vpc_private_subnets                   = module.vpc.vpc_private_subnets
  vpc_nat_public_ips                    = module.vpc.vpc_nat_public_ips
  cluster_name                          = var.cluster_name
  map_users                             = var.map_users
  kubernetes_version                    = var.kubernetes_version
  cluster_endpoint_public_access_cidrs  = var.cluster_endpoint_public_access_cidrs
  default_node_pool_instance_type       = var.default_node_pool_instance_type
  default_node_pool_ami_type            = var.default_node_pool_ami_type
  default_node_pool_disk_size           = var.default_node_pool_disk_size
  default_node_pool_capacity_type       = var.default_node_pool_capacity_type
  default_node_pool_min_size            = var.default_node_pool_min_size
  default_node_pool_max_size            = var.default_node_pool_max_size
  jobfarm_node_pool_instance_type       = var.jobfarm_node_pool_instance_type
  jobfarm_node_pool_ami_type            = var.jobfarm_node_pool_ami_type
  jobfarm_node_pool_disk_size           = var.jobfarm_node_pool_disk_size
  jobfarm_node_pool_capacity_type       = var.jobfarm_node_pool_capacity_type
  jobfarm_node_pool_min_size            = var.jobfarm_node_pool_min_size
  jobfarm_node_pool_max_size            = var.jobfarm_node_pool_max_size
  deploy_autoscaler                     = var.deploy_autoscaler
  cluster_autoscaler_helm_chart_version = var.cluster_autoscaler_helm_chart_version
  deploy_ingress_controller             = var.deploy_ingress_controller
  ingress_controller_helm_chart_version = var.ingress_controller_helm_chart_version
  tags                                  = var.tags
}

module "s3_bucket" {
  source         = "./s3-bucket"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  aws_region     = var.aws_region
  create_bucket  = var.scanfarm_enabled ? true : false
  prefix         = var.prefix
  bucket_name    = var.bucket_name
  expire_after   = var.expire_after
  tags           = var.tags
}

module "rds_instance" {
  source              = "./rds-instance"
  aws_access_key      = var.aws_access_key
  aws_secret_key      = var.aws_secret_key
  aws_region          = var.aws_region
  create_db_instance  = length(var.db_name) > 0 ? false : true
  prefix              = var.prefix
  db_vpc_id           = module.vpc.vpc_id
  db_vpc_cidr_blocks  = [module.vpc.vpc_cidr_block]
  db_private_subnets  = module.vpc.vpc_private_subnets
  db_name             = var.db_name
  db_postgres_version = var.db_postgres_version
  db_username         = var.db_username
  db_password         = var.db_password
  db_port             = var.db_port
  db_public_access    = var.db_public_access
  db_instance_class   = var.db_instance_class
  db_size_in_gb       = var.db_size_in_gb
  tags                = var.tags
}

# module "create_secrets_in_namespace" {
#   source           = "./secrets"
#   aws_access_key   = var.aws_access_key
#   aws_secret_key   = var.aws_secret_key
#   aws_region       = var.aws_region
#   prefix           = var.prefix
#   cluster_name     = module.eks_cluster.cluster_name
#   create_db_secret = var.create_db_secret
#   db_host          = module.rds_instance.db_instance_address
#   db_port          = module.rds_instance.db_instance_port
#   db_username      = module.rds_instance.db_instance_username
#   db_password      = length(var.db_password) > 0 ? var.db_password : module.rds_instance.db_master_password
#   create_s3_secret = var.create_s3_secret
#   bucket_name      = module.s3_bucket.s3_bucket_name
#   bucket_region    = module.s3_bucket.s3_bucket_region
# }

