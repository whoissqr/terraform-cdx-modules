provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

locals {
  namespace = replace(lower(var.prefix), "/[^a-zA-Z0-9]/", "")
}

# Get the eks cluster resources
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

# Get the eks cluster auth resources to connect the cluster
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth
data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

# Connect to the kubernetes cluster
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Create the kubernetes namespace if any of secret creation is enabled
resource "kubernetes_namespace" "create_ns" {
  count = (var.create_db_secret || var.create_s3_secret) ? 1 : 0
  metadata {
    name = local.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

# Create the db credentials secret in kubernetes namespace
resource "kubernetes_secret" "cnc_db_credentials" {
  count = var.create_db_secret ? 1 : 0
  metadata {
    name      = "cnc-db-credentials"
    namespace = local.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  data = {
    host     = var.db_host
    port     = var.db_port
    username = var.db_username
    password = var.db_password
  }

  lifecycle {
    ignore_changes = [
      data["password"],
    ]
  }
}

# Create the s3 credentials secret in kubernetes namespace
resource "kubernetes_secret" "cnc_s3_credentials" {
  count = var.create_s3_secret ? 1 : 0
  metadata {
    name      = "cnc-s3-credentials"
    namespace = local.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  data = {
    access_key    = var.aws_access_key
    secret_key    = var.aws_secret_key
    bucket_name   = var.bucket_name
    bucket_region = var.bucket_region
  }
}
