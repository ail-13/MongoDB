locals {
  env = "stage"
}
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
  project     = var.project
  # region  = var.region
}

# Кластер Kubernetes
module "k8s" {
  source       = "./../modules/k8s"
  name         = var.project_name
  worker_count = var.worker_count
  env          = local.env
  zone         = var.zone
}
