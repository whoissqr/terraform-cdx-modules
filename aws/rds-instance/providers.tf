terraform {
  required_version = ">= 0.14.7"
  required_providers {
    aws = ">= 3.40.0"
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }
}
