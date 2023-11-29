variable "source_ranges" {
  description = "Разрешенные ip-адреса"
}
variable "name" {
  description = "Название сервиса, оно используется в качестве тега"
}
variable "env" {
  type        = string
  description = "Окружение"
}
