provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Generate a random password if db_password var is empty
resource "random_string" "password" {
  count   = var.create_db_instance && length(var.db_password) == 0 ? 1 : 0
  length  = 16
  special = false
}

locals {
  is_rds_instance_exist = length(var.db_name) > 0 ? true : false
  namespace             = replace(lower(var.prefix), "/[^a-zA-Z0-9]/", "")
  db_name               = "${local.namespace}mariadb"
}

# Create the mariadb security group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "allow_mariadb" {
  count       = var.create_db_instance ? 1 : 0
  name        = "${local.namespace}-mariadb-sg"
  description = "Allow mariadb inbound traffic"
  vpc_id      = var.db_vpc_id
  tags        = var.tags
}

# Create the mariadb inbound security group rule
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule
resource "aws_security_group_rule" "allow_mariadb_rule_inbound" {
  count             = var.create_db_instance ? 1 : 0
  type              = "ingress"
  from_port         = var.db_port
  to_port           = var.db_port
  protocol          = "tcp"
  security_group_id = aws_security_group.allow_mariadb.0.id
  cidr_blocks       = var.db_vpc_cidr_blocks
}

# Shi Chao, create db param group for mariaDB
resource "aws_db_parameter_group" "pname_group" {
    name   = "${local.namespace}-mariadb-db-parameter-group"
    family = "mariadb10.6"

    parameter {
      name                            = "optimizer_search_depth"
      value                           = "0"
      apply_method                    = "pending-reboot"
    }

    parameter {
      name                            = "character_set_server"
      value                           = "utf8mb4"
      apply_method                    = "pending-reboot"
    }

    parameter {
      name                            = "collation_server"
      value                           = "utf8mb4_general_ci"
      apply_method                    = "pending-reboot"
    }

    parameter {
      name                            = "lower_case_table_names"
      value                           = "1"
      apply_method                    = "pending-reboot"
    }

    parameter {
      name                            = "log_bin_trust_function_creators"
      value                           = "1"
      apply_method                    = "pending-reboot"
    }
}

# Create the rds instance if create_db_instance flag is enabled
# https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/3.3.0
module "rds" {
  source                    = "terraform-aws-modules/rds/aws"
  version                   = "3.3.0"
  create_db_instance        = var.create_db_instance
  create_db_parameter_group = var.create_db_instance
  create_db_subnet_group    = var.create_db_instance
  identifier                = "${local.namespace}-mariadb"

  engine               = "mariadb"
  engine_version       = var.db_mariadb_version
  major_engine_version = var.db_mariadb_version
  instance_class       = var.db_instance_class
  family               = "mariadb${var.db_mariadb_version}"
  allocated_storage    = var.db_size_in_gb
  storage_type         = "gp2"

  #name     = local.db_name
  name     = "codedxdb"
  username = var.db_username
  password = local.is_rds_instance_exist || length(var.db_password) > 0 ? var.db_password : random_string.password.0.result
  port     = var.db_port
  tags     = var.tags

  maintenance_window      = "Sun:00:00-Sun:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 0

  enabled_cloudwatch_logs_exports = ["audit","error","general","slowquery"]
  vpc_security_group_ids          = var.create_db_instance ? [aws_security_group.allow_mariadb.0.id] : []
  parameter_group_name            = aws_db_parameter_group.pname_group.name
  subnet_ids                      = var.db_private_subnets
  publicly_accessible             = var.db_public_access
  skip_final_snapshot             = true
  deletion_protection             = false
}

# If rds instance already exists
data "aws_db_instance" "default" {
  count                  = local.is_rds_instance_exist ? 1 : 0
  db_instance_identifier = var.db_name
}
