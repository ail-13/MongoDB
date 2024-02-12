variable "vdc" {
  type = object({
    zone   = string
    alias  = string
    region = string
  })
  description = "Датацентр"
}
variable "vm_name" {
  type        = string
  description = "Название сервера"
}
variable "vm_username" {
  type        = string
  description = "Имя пользователя который будет создан на сервере"
}
variable "vm_image" {
  type        = string
  description = "Название образа виртуальной машины"
}
variable "vm_ssh_port" {
  default     = 22
  type        = number
  description = "Порт ssh"

  validation {
    condition     = var.vm_ssh_port == 22 || var.vm_ssh_port > 1000 && var.vm_ssh_port < 65535
    error_message = "Значение vm_ssh_port должно быть в диапазоне от 1000 до 65535"
  }
}
variable "vm_networks" {
  description = "Список сетей для подключения"
  type = list(object({
    network       = string
    subnetwork    = string
    subnetwork_ip = string
  }))

  validation {
    condition     = alltrue([for n in var.vm_networks : can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$", n.subnetwork_ip))])
    error_message = "Каждое поле subnetwork_ip должно быть IP адресом"
  }
}
variable "vm_machine_type" {
  type        = string
  description = "Тип сервера"
}
variable "public_key_path" {
  type        = string
  description = "Путь к публичному ssh-ключу"
}
variable "vapp_name" {
  type        = string
  description = "Название приложения"
}
variable "vm_metadata" {
  default = []
  type = list(object({
    key   = string
    value = string
  }))
  description = "Дополнительные пользовательские параметры"
}
