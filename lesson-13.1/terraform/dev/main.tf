locals {
  env          = "dev"
  project_name = "lesson-13"
  vapp_name    = "${local.env}-${local.project_name}"
}

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
  project     = var.gcp_project
}

module "master_1" {
  source          = "./../modules/vm"
  vapp_name       = local.vapp_name
  vm_username     = var.vm_username
  public_key_path = var.public_key_path
  vdc             = var.gcp_vdc_g
  vm_name         = "k8s-master-1"
  vm_image        = "ubuntu-2004-lts"
  vm_machine_type = "e2-medium"
  vm_networks = [
    {
      network       = module.gcp_network.network
      subnetwork    = module.gcp_network.subnetwork
      subnetwork_ip = "192.168.0.10"
    }
  ]
  depends_on = [module.gcp_network]
}

module "master_2" {
  source          = "./../modules/vm"
  vapp_name       = local.vapp_name
  vm_username     = var.vm_username
  public_key_path = var.public_key_path
  vdc             = var.gcp_vdc_g
  vm_name         = "k8s-master-2"
  vm_image        = "ubuntu-2004-lts"
  vm_machine_type = "e2-medium"
  vm_networks = [
    {
      network       = module.gcp_network.network
      subnetwork    = module.gcp_network.subnetwork
      subnetwork_ip = "192.168.0.11"
    }
  ]
  depends_on = [module.gcp_network]
}

module "master_3" {
  source          = "./../modules/vm"
  vapp_name       = local.vapp_name
  vm_username     = var.vm_username
  public_key_path = var.public_key_path
  vdc             = var.gcp_vdc_g
  vm_name         = "k8s-master-3"
  vm_image        = "ubuntu-2004-lts"
  vm_machine_type = "e2-medium"
  vm_networks = [
    {
      network       = module.gcp_network.network
      subnetwork    = module.gcp_network.subnetwork
      subnetwork_ip = "192.168.0.12"
    }
  ]
  depends_on = [module.gcp_network]

}

module "worker_1" {
  source          = "./../modules/vm"
  vapp_name       = local.vapp_name
  vm_username     = var.vm_username
  public_key_path = var.public_key_path
  vdc             = var.gcp_vdc_g
  vm_name         = "k8s-worker-1"
  vm_image        = "ubuntu-2004-lts"
  vm_machine_type = "e2-medium"
  vm_networks = [
    {
      network       = module.gcp_network.network
      subnetwork    = module.gcp_network.subnetwork
      subnetwork_ip = "192.168.0.13"
    }
  ]
  depends_on = [module.gcp_network]
}

module "worker_2" {
  source          = "./../modules/vm"
  vapp_name       = local.vapp_name
  vm_username     = var.vm_username
  public_key_path = var.public_key_path
  vdc             = var.gcp_vdc_g
  vm_name         = "k8s-worker-2"
  vm_image        = "ubuntu-2004-lts"
  vm_machine_type = "e2-medium"
  vm_networks = [
    {
      network       = module.gcp_network.network
      subnetwork    = module.gcp_network.subnetwork
      subnetwork_ip = "192.168.0.14"
    }
  ]
  depends_on = [module.gcp_network]
}

module "worker_3" {
  source          = "./../modules/vm"
  vapp_name       = local.vapp_name
  vm_username     = var.vm_username
  public_key_path = var.public_key_path
  vdc             = var.gcp_vdc_g
  vm_name         = "k8s-worker-3"
  vm_image        = "ubuntu-2004-lts"
  vm_machine_type = "e2-medium"
  vm_networks = [
    {
      network       = module.gcp_network.network
      subnetwork    = module.gcp_network.subnetwork
      subnetwork_ip = "192.168.0.15"
    }
  ]
  depends_on = [module.gcp_network]
}

module "gcp_network" {
  source           = "./../modules/network"
  vapp_name        = local.vapp_name
  vdc              = var.gcp_vdc_g
  network_name     = "network"
  network_ip_range = "192.168.0.0/24"
}

module "gcp_firewall" {
  source           = "./../modules/firewall"
  firewall_network = module.gcp_network.network
  firewall_rules = [
    {
      ports  = [22]
      source = ["0.0.0.0/0"]
      dest = [
        module.master_1.name,
        module.master_2.name,
        module.master_3.name,
        module.worker_1.name,
        module.worker_2.name,
        module.worker_3.name,
      ]
    },
    {
      ports  = [80]
      source = ["0.0.0.0/0"]
      dest = [
        module.worker_1.name,
        module.worker_2.name,
        module.worker_3.name
      ]
    },
    {
      ports  = [443]
      source = ["0.0.0.0/0"]
      dest = [
        module.worker_1.name,
        module.worker_2.name,
        module.worker_3.name
      ]
    },
    {
      ports = [
        6443,
        2379,
        2380,
        10257,
        10259
      ]
      source = ["192.168.0.0/24"]
      dest = [
        module.master_1.name,
        module.master_2.name,
        module.master_3.name
      ]
    },
    {
      ports = [
        10250
      ]
      source = ["192.168.0.0/24"]
      dest = [
        module.master_1.name,
        module.master_2.name,
        module.master_3.name,
        module.worker_1.name,
        module.worker_2.name,
        module.worker_3.name
      ]
    },
    {
      ports = [
        "30000-32767"
      ]
      source = ["0.0.0.0/0"]
      dest = [
        module.worker_1.name,
        module.worker_2.name,
        module.worker_3.name
      ]
    }
  ]
}
