locals {
  env          = "dev"
  project_name = "project"
  vapp_name    = "${local.env}-${local.project_name}"
}

module "monitoring" {
  source            = "./../modules/vm"
  vapp_name         = local.vapp_name
  vm_username       = var.vm_username
  public_key_path   = var.public_key_path
  zone              = var.zone
  vm_name           = "monitoring"
  vm_image          = "ubuntu-2004-lts"
  vm_data_disk_size = 10
  vm_machine_type   = "e2-medium"
  vm_networks = [
    {
      network       = module.network.network
      subnetwork    = module.network.subnetwork
      subnetwork_ip = "192.168.0.2"
    }
  ]
  depends_on = [module.network]
}

module "db_1" {
  source            = "./../modules/vm"
  vapp_name         = local.vapp_name
  vm_username       = var.vm_username
  public_key_path   = var.public_key_path
  zone              = var.zone
  vm_name           = "db-1"
  vm_image          = "ubuntu-2004-lts"
  vm_data_disk_size = 10
  vm_machine_type   = "e2-small"
  vm_networks = [
    {
      network       = module.network.network
      subnetwork    = module.network.subnetwork
      subnetwork_ip = "192.168.0.3"
    }
  ]
  vm_metadata = [
    {
      key   = "mongodb_role"
      value = "PRIMARY"
    }
  ]
  depends_on = [module.network]
}

module "db_2" {
  source            = "./../modules/vm"
  vapp_name         = local.vapp_name
  vm_username       = var.vm_username
  public_key_path   = var.public_key_path
  zone              = var.zone
  vm_name           = "db-2"
  vm_image          = "ubuntu-2004-lts"
  vm_data_disk_size = 10
  vm_machine_type   = "e2-small"
  vm_networks = [
    {
      network       = module.network.network
      subnetwork    = module.network.subnetwork
      subnetwork_ip = "192.168.0.4"
    }
  ]
  vm_metadata = [
    {
      key   = "mongodb_role"
      value = "SECONDARY"
    }
  ]
  depends_on = [module.network]
}

module "db_3" {
  source            = "./../modules/vm"
  vapp_name         = local.vapp_name
  vm_username       = var.vm_username
  public_key_path   = var.public_key_path
  zone              = var.zone
  vm_name           = "db-3"
  vm_image          = "ubuntu-2004-lts"
  vm_data_disk_size = 10
  vm_machine_type   = "e2-small"
  vm_networks = [
    {
      network       = module.network.network
      subnetwork    = module.network.subnetwork
      subnetwork_ip = "192.168.0.5"
    }
  ]
  vm_metadata = [
    {
      key   = "mongodb_role"
      value = "SECONDARY"
    }
  ]
  depends_on = [module.network]
}

module "app_1" {
  source          = "./../modules/vm"
  vapp_name       = local.vapp_name
  vm_username     = var.vm_username
  public_key_path = var.public_key_path
  zone            = var.zone
  vm_name         = "app-1"
  vm_image        = "ubuntu-2004-lts"
  vm_machine_type = "e2-small"
  vm_networks = [
    {
      network       = module.network.network
      subnetwork    = module.network.subnetwork
      subnetwork_ip = "192.168.0.6"
    }
  ]
  depends_on = [module.network]
}

module "network" {
  source           = "./../modules/network"
  vapp_name        = local.vapp_name
  region           = var.region
  network_name     = "network"
  network_ip_range = "192.168.0.0/24"
}

module "firewall" {
  source = "./../modules/firewall"

  firewall_network = module.network.network
  firewall_rules = [
    {
      ports  = [22]
      source = ["0.0.0.0/0"]
      dest = [
        module.monitoring.name,
        module.db_1.name,
        module.db_2.name,
        module.db_3.name,
        module.app_1.name
      ]
    },
    {
      ports  = [27017]
      source = ["0.0.0.0/0"]
      dest = [
        module.monitoring.name,
        module.db_1.name,
        module.db_2.name,
        module.db_3.name
      ]
    },
    {
      ports  = [80]
      source = ["0.0.0.0/0"]
      dest = [
        module.app_1.name
      ]
    },
    {
      ports  = [443]
      source = ["0.0.0.0/0"]
      dest = [
        module.monitoring.name,
        module.app_1.name
      ]
    }
  ]
}
