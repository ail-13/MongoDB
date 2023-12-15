output "_env" {
  value = local.env
}

output "inventory" {
  value = {
    _meta : {
      hostvars : merge(
        {
          for instance in module.db.instances : instance.name => {
            ansible_host = instance.ip
            vm_disk      = instance.disk
            vm_username  = var.username
          }
        },
        {
          for instance in module.app.instances : instance.name => {
            ansible_host = instance.ip
            mongodb_ip   = module.db.instances[*].ip
            vm_username  = var.username
          }
        },
        {
          for instance in module.monitoring.instances : instance.name => {
            ansible_host = instance.ip
            mongodb_ip   = module.db.instances[*].ip
            vm_username  = var.username
          }
        }
      )
    },
    app : {
      hosts : [
        for instance in module.app.instances : instance.name
      ]
    },
    db : {
      hosts : [
        for instance in module.db.instances : instance.name
      ]
    },
    monitoring : {
      hosts : [
        for instance in module.monitoring.instances : instance.name
      ]
    }
  }
}
