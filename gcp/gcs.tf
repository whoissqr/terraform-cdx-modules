resource "google_storage_bucket" "uploads-bucket" {
  count         = local.is_bucket_exist ? 0 : 1
  name          = "${local.namespace}-uploads-bucket"
  location      = var.gcp_region
  force_destroy = true # Delete even if non-empty

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age        = var.expire_after
      with_state = "ANY"
    }
  }
  labels = var.tags
}


