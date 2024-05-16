# Set up requirements and backend

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.26.0"
    }
  }
  # backend "gcs" { # we use local state for now
  #   bucket = "where to put the state file"
  #   # prefix = "tfstate"
  # }
}

# Set up provider

provider "google" {
  project = "amedia-adp-test"
  default_labels = {
    managed-by = "terraform"
  }
  region = "europe-north1"
}

## Add resources below


