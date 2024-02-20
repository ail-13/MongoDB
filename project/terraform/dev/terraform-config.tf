terraform {
  required_version = "1.6.6"

  required_providers {
    google = {
      version = "5.2.0"
    }
  }
}

provider "google" {
  credentials = "./../credentials.json"
  project     = var.project
}
