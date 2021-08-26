provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

locals {
  namespace       = replace(lower(var.prefix), "/[^a-zA-Z0-9]/", "")
  is_bucket_exist = length(var.bucket_name) > 0 ? true : false
}

# Create the s3 bucket if create_bucket flag is enabled
# https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/2.7.0
module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "2.7.0"
  create_bucket = var.create_bucket
  bucket        = "${local.namespace}-uploads-bucket"
  force_destroy = true
  lifecycle_rule = [
    {
      id      = "${local.namespace}-uploads-bucket-expiration-rule"
      enabled = true
      expiration = {
        days = var.expire_after
      }
      tags = {
        name         = "${local.namespace}-uploads-bucket"
        rule         = "force-delete"
        expire_after = var.expire_after
      }
    }
  ]
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  tags                    = var.tags
}

# If bucket already exists
data "aws_s3_bucket" "default" {
  count  = local.is_bucket_exist ? 1 : 0
  bucket = var.bucket_name
}
