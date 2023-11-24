terraform {
  # Версия terraform
  required_version = "1.6.4"
  required_providers {
    google = {
      # Версия провайдера
      version = "5.2.0"
    }
  }
}
provider "google" {
  # ID проекта
  credentials = file(var.credentials)
  project     = var.project
  # region  = var.region
}

module "vm" {
  source           = "./modules/vm"
  vm_name          = var.vm_name
  zone             = var.zone
  username         = var.username
  private_key_path = var.private_key_path
}
module "vpc" {
  source        = "./modules/vpc"
  source_ranges = var.firewall_filter
  name          = var.vm_name
}
