variable "region" {
  type        = string
  description = "Датацентр"
}
variable "network_name" {
  type        = string
  description = "Название сети"

  validation {
    condition     = can(regex("^(?:[a-z](?:[-a-z0-9]{0,61}[a-z0-9])?)$", var.network_name))
    error_message = "Значение network_name должно быть в нижнем регистре и содержать только латинские буквы, цифры и дефисы"
  }
}
variable "network_ip_range" {
  type        = string
  description = "IP диапазон для сети"

  validation {
    condition     = can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\/\\d{1,2}$", var.network_ip_range))
    error_message = "Значение network_ip_range должно быть IP диапазоном"
  }
}
variable "vapp_name" {
  type        = string
  description = "Название приложения"
}
