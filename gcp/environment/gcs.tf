resource "google_storage_bucket" "uploads-bucket" {
  count         = var.scanfarm_enabled ? 1 : 0
  name          = "${local.namespace}-uploads-bucket"
  location      = var.bucket_region
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


