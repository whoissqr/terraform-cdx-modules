output "s3_bucket_name" {
  value = local.is_bucket_exist ? data.aws_s3_bucket.default.0.id : module.s3_bucket.s3_bucket_id
}

output "s3_bucket_region" {
  value = local.is_bucket_exist ? data.aws_s3_bucket.default.0.region : module.s3_bucket.s3_bucket_region
}
