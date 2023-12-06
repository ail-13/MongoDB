output "_env" {
  value = "prod"
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
            mongodb_ip   = module.db.instances[0].ip
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
    }
  }
}
