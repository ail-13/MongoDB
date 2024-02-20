locals {
  instances = [
    module.monitoring,
    module.db_1,
    module.db_2,
    module.db_3,
    module.app_1
  ]
}

output "inventory" {
  value = {
    _meta : {
      hostvars = merge(
        { for instance in local.instances : instance.name => {
            ansible_host   = instance.external_ip
            ansible_port   = instance.ssh_port
            ansible_user   = var.vm_username
            vm_disk        = instance.disk
            vm_metadata    = instance.metadata
            vm_internal_ip = instance.internal_ip
            preconfig_hosts = [
              for inst in local.instances : "${inst.internal_ip[0]} ${inst.name}"
            ]
          }
        }
      )
    },
    app : {
      hosts : [
        module.app_1.name
      ]
    },
    db : {
      hosts : [
        module.db_1.name,
        module.db_2.name,
        module.db_3.name
      ]
    },
    monitoring : {
      hosts : [
        module.monitoring.name
      ]
    }
  }
}

output "monitoring" {
  value = "https://${module.monitoring.external_ip}"
}

output "hosts" {
  value = <<EOF
${module.db_1.external_ip} ${module.db_1.name}
${module.db_2.external_ip} ${module.db_2.name}
${module.db_3.external_ip} ${module.db_3.name}
  EOF
}
