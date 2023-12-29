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
  backend "gcs" {
    bucket      = "tfstate-backet-lesson-9"
    prefix      = "stage/state.infra"
    credentials = "./../credentials.json"
  }
}
provider "google" {
  # ID проекта
  credentials = "./../credentials.json"
  project     = var.project
  # region  = var.region
}

# Сервера приложения
module "app" {
  source           = "./../modules/vm"
  vm_name          = "${var.project_name}-app"
  zone             = var.zone
  username         = var.username
  private_key_path = var.private_key_path
  create_disk      = false
  vm_count         = var.app_count
  env              = local.env
}

# Сервера БД
module "db" {
  source           = "./../modules/vm"
  vm_name          = "${var.project_name}-db"
  zone             = var.zone
  username         = var.username
  private_key_path = var.private_key_path
  create_disk      = true
  env              = local.env
  vm_count         = var.db_count
}

# Сервер мониторинга
module "monitoring" {
  source           = "./../modules/vm"
  vm_name          = "${var.project_name}-monitoring"
  zone             = var.zone
  username         = var.username
  private_key_path = var.private_key_path
  create_disk      = true
  env              = local.env
  vm_count         = 1
}

# Открываем порты для сервера с БД
module "db_mongodb_port" {
  source = "./../modules/vpc"
  source_ranges = concat(
    module.db.instances[*].ip,
    module.app.instances[*].ip,
    module.monitoring.instances[*].ip,
    var.mongodb_source_ranges
  )
  vm_name  = "${var.project_name}-db"
  ports    = [var.mongodb_port]
  env      = local.env
  vm_count = var.db_count
}
# Открываем порты для сервера с мониторингом
module "monitoring_web_port" {
  source        = "./../modules/vpc"
  source_ranges = var.monitoring_source_ranges
  vm_name       = "${var.project_name}-monitoring"
  ports         = [80, 443]
  env           = local.env
  vm_count      = 1
}
# Открываем порты для сервера с приложением
module "app_web_port" {
  source        = "./../modules/vpc"
  source_ranges = ["0.0.0.0/0"]
  vm_name       = "${var.project_name}-app"
  ports         = [80, 443]
  env           = local.env
  vm_count      = var.app_count
}
