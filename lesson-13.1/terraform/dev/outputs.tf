output "inventory" {
  value = {
    _meta : {
      hostvars : merge(
        {
          "${module.master_1.name}" = {
            ansible_host = module.master_1.external_ip
            ansible_port = module.master_1.ssh_port
            ansible_user = var.vm_username
            ip           = module.master_1.internal_ip[0]
          }
        },
        {
          "${module.master_2.name}" = {
            ansible_host = module.master_2.external_ip
            ansible_port = module.master_2.ssh_port
            ansible_user = var.vm_username
            ip           = module.master_2.internal_ip[0]
          }
        },
        {
          "${module.master_3.name}" = {
            ansible_host = module.master_3.external_ip
            ansible_port = module.master_3.ssh_port
            ansible_user = var.vm_username
            ip           = module.master_3.internal_ip[0]
          }
        },
        {
          "${module.worker_1.name}" = {
            ansible_host = module.worker_1.external_ip
            ansible_port = module.worker_1.ssh_port
            ansible_user = var.vm_username
            ip           = module.worker_1.internal_ip[0]
          }
        },
        {
          "${module.worker_2.name}" = {
            ansible_host = module.worker_2.external_ip
            ansible_port = module.worker_2.ssh_port
            ansible_user = var.vm_username
            ip           = module.worker_2.internal_ip[0]
          }
        },
        {
          "${module.worker_3.name}" = {
            ansible_host = module.worker_3.external_ip
            ansible_port = module.worker_3.ssh_port
            ansible_user = var.vm_username
            ip           = module.worker_3.internal_ip[0]
          }
        },
      )
    },
    kube_control_plane : {
      hosts : [
        module.master_1.name,
        module.master_2.name,
        module.master_3.name
      ]
    },
    etcd : {
      hosts : [
        module.master_1.name,
        module.master_2.name,
        module.master_3.name
      ]
    },
    kube_node : {
      hosts : [
        module.worker_1.name,
        module.worker_2.name,
        module.worker_3.name
      ]
    },
    k8s_cluster : {
      children : [
        "kube_control_plane",
        "kube_node"
      ]
    }
  }
}
