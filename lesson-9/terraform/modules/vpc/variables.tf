variable "source_ranges" {
  description = "Разрешенные ip-адреса"
}
variable "vm_name" {
  description = "Название сервиса, оно используется в качестве тега"
}
variable "env" {
  type        = string
  description = "Окружение"
}

variable "vm_count" {
  description = "Количество серверов"
}

variable "ports" {
  description = "Порты которые нужно открыть"
}
