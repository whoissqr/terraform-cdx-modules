terraform {
  required_version = ">= 0.14.7"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.82"
    }
  }
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

provider "google-beta" {
  region  = var.gcp_region
  project = var.gcp_project
  alias   = "beta"
}

data "google_client_config" "provider" {}

data "google_container_cluster" "default" {
  name     = var.gcp_cluster_name
  location = "us-east1"
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.default.endpoint}"
  cluster_ca_certificate = base64decode(data.google_container_cluster.default.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.provider.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.default.endpoint}"
    cluster_ca_certificate = base64decode(data.google_container_cluster.default.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.provider.access_token
  }
}
