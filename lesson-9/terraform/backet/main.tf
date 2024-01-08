terraform {
  # Версия terraform
  required_version = "~> 1.6.4"
  required_providers {
    google = {
      # Версия провайдера
      version = "5.2.0"
    }
  }
}
provider "google" {
  # ID проекта
  credentials = "./../credentials.json"
  project     = "mongo-407516"
  # region  = var.region
}

resource "google_storage_bucket" "terraform_state" {
  name          = "tfstate-backet-lesson-9"
  location      = "EU"
  force_destroy = false
  storage_class = "NEARLINE"

  versioning {
    enabled = true
  }
}
