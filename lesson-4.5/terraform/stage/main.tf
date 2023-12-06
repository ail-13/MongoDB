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

module "app" {
  source           = "./../modules/vm"
  vm_name          = "${var.project_name}-app"
  zone             = var.zone
  username         = var.username
  private_key_path = var.private_key_path
  create_disk      = false
  vm_count         = var.vm_count
  env              = "stage"
}
module "vpc_app" {
  source        = "./../modules/vpc"
  source_ranges = var.firewall_filter
  name          = "${var.project_name}-app"
  env           = "stage"
  vm_count      = var.vm_count
}

module "db" {
  source           = "./../modules/vm"
  vm_name          = "${var.project_name}-db"
  zone             = var.zone
  username         = var.username
  private_key_path = var.private_key_path
  create_disk      = true
  env              = "stage"
  vm_count         = var.vm_count
}
module "vpc_db" {
  source        = "./../modules/vpc"
  source_ranges = var.firewall_filter
  name          = "${var.project_name}-db"
  env           = "stage"
  vm_count         = var.vm_count
}
