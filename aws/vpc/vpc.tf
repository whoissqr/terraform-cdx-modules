provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Get the list of available zones
data "aws_availability_zones" "available" {
}

# Generate the cidr_block range for public subnets
data "template_file" "public_cidrs" {
  count    = 2
  template = cidrsubnet(var.vpc_cidr_block, 8, count.index)
}

# Generate the cidr_block range for private subnets
data "template_file" "private_cidrs" {
  count    = 2
  template = cidrsubnet(var.vpc_cidr_block, 8, count.index + 2)
}

# Create the vpc if create_vpc flag is enabled
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/3.6.0
module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  create_vpc           = var.create_vpc
  version              = "3.6.0"
  name                 = "${var.prefix}-vpc"
  cidr                 = var.vpc_cidr_block
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = data.template_file.public_cidrs.*.rendered
  private_subnets      = data.template_file.private_cidrs.*.rendered
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  tags                 = var.tags
}

# If vpc already exists
locals {
  is_vpc_exist = length(var.vpc_id) > 0 ? true : false
}

# Get the cidr_block of the given vpc
data "aws_vpc" "default" {
  count = local.is_vpc_exist ? 1 : 0
  id    = var.vpc_id
}

# Get the list of subnets from the given vpc
data "aws_subnets" "default" {
  count = local.is_vpc_exist ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# Filter the public/private subnets of the given vpc
data "aws_subnet" "default" {
  for_each = local.is_vpc_exist ? toset(data.aws_subnets.default.0.ids) : toset([])
  id       = each.value
}

# Get the nat gateway public ip of the given vpc
data "aws_nat_gateway" "default" {
  count  = local.is_vpc_exist ? 1 : 0
  vpc_id = var.vpc_id
}
