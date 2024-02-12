variable "firewall_rules" {
  type = list(object({
    ports  = list(string)
    source = list(string)
    dest   = list(string)
  }))
  description = "Список правил для фаервола"

  validation {
    condition = alltrue([
      for rule in var.firewall_rules :
      alltrue([for ip in rule.source : can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}(\\/\\d{1,2})?|any$", ip))])
    ])
    error_message = "Каждое поле source должны быть валидными IP адресами или диапазоном."
  }
}
variable "firewall_network" {
  type        = string
  description = "Сеть"
}
