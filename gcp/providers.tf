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
