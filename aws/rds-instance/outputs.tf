output "db_instance_address" {
  value = local.is_rds_instance_exist ? data.aws_db_instance.default.0.address : module.rds.db_instance_address
}

output "db_instance_port" {
  value = local.is_rds_instance_exist ? data.aws_db_instance.default.0.port : module.rds.db_instance_port
}

output "db_instance_username" {
  value     = local.is_rds_instance_exist ? data.aws_db_instance.default.0.master_username : module.rds.db_instance_username
  sensitive = true
}

output "db_master_password" {
  value     = local.is_rds_instance_exist ? var.db_password : module.rds.db_master_password
  sensitive = true
}

output "db_instance_name" {
  value = local.is_rds_instance_exist ? data.aws_db_instance.default.0.db_name : module.rds.db_instance_name
}

output "db_subnet_group_id" {
  value = local.is_rds_instance_exist ? data.aws_db_instance.default.0.db_subnet_group : module.rds.db_subnet_group_id
}
