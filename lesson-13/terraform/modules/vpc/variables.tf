variable "source_ranges" {
  type        = list(string)
  description = "Разрешенные ip-адреса"
}
variable "vm_name" {
  type        = string
  description = "Название сервиса, оно используется в качестве тега"
}
variable "env" {
  type        = string
  description = "Окружение"
}

variable "vm_count" {
  type        = number
  description = "Количество серверов"
}

variable "ports" {
  type        = list(number)
  description = "Порты которые нужно открыть"
}
