resource "google_service_account" "gcs_sa" {
  count        = var.scanfarm_enabled ? 1 : 0
  account_id   = "${local.namespace}-gcs-sa"
  display_name = "service account for ${local.namespace} environment"
}

resource "google_service_account_key" "gcs_sa_key" {
  count              = var.scanfarm_enabled ? 1 : 0
  service_account_id = google_service_account.gcs_sa.0.name
}

resource "google_project_iam_member" "gcs_sa_binding" {
  count   = var.scanfarm_enabled ? 1 : 0
  project = var.gcp_project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.gcs_sa.0.email}"
}

# resource "kubernetes_namespace" "create_ns" {
#   count = length(var.app_namespace) == 0 ? 1 : 0
#   metadata {
#     name = local.namespace
#     labels = {
#       "app.kubernetes.io/managed-by" = "terraform"
#     }
#   }
# }

# resource "kubernetes_secret" "gcs_sa_k8s_secret" {
#   count = var.create_gcs_secret ? 1 : 0
#   depends_on = [
#     kubernetes_namespace.create_ns
#   ]
#   metadata {
#     name      = "cnc-gcs-credentials"
#     namespace = local.namespace
#     labels = {
#       "app.kubernetes.io/managed-by" = "terraform"
#     }
#   }

#   data = {
#     "key.json"    = base64decode(google_service_account_key.gcs_sa_key.0.private_key)
#     bucket_name   = local.is_bucket_exist ? var.bucket_name : google_storage_bucket.uploads-bucket[0].name
#     bucket_region = var.bucket_region
#   }
# }

# resource "kubernetes_secret" "cnc_db_credentials" {
#   count = var.create_db_secret ? 1 : 0
#   depends_on = [
#     kubernetes_namespace.create_ns
#   ]
#   metadata {
#     name      = "cnc-db-credentials"
#     namespace = local.namespace
#     labels = {
#       "app.kubernetes.io/managed-by" = "terraform"
#     }
#   }

#   data = {
#     host     = local.is_cloudsql_instance_exist ? var.db_host : google_sql_database_instance.master.0.private_ip_address
#     port     = var.db_port
#     username = local.is_cloudsql_instance_exist ? var.db_username : google_sql_user.user.0.name
#     password = local.is_cloudsql_instance_exist ? var.db_password : random_string.password.0.result
#   }

#   lifecycle {
#     ignore_changes = [
#       data["password"],
#     ]
#   }
# }

# # Client certs for TLS setup with PgBouncer
# resource "google_sql_ssl_cert" "client_cert" {
#   count       = var.db_require_ssl ? 1 : 0
#   common_name = "client-cert"
#   instance    = local.is_cloudsql_instance_exist ? var.db_name : google_sql_database_instance.master.0.name
# }

# resource "kubernetes_secret" "db_ssl_secret" {
#   count = var.db_require_ssl ? 1 : 0
#   depends_on = [
#     kubernetes_namespace.create_ns
#   ]
#   metadata {
#     name      = "cnc-db-ssl-cert"
#     namespace = local.namespace
#     labels = {
#       "app.kubernetes.io/managed-by" = "terraform"
#     }
#   }

#   data = {
#     "serverCert.crt" = google_sql_ssl_cert.client_cert.0.server_ca_cert
#     "clientKey.key"  = google_sql_ssl_cert.client_cert.0.private_key
#     "clientCert.crt" = google_sql_ssl_cert.client_cert.0.cert
#   }
# }
