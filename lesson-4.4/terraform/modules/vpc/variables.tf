variable "source_ranges" {
  description = "Разрешенные ip-адреса"
  default     = ["0.0.0.0/0"]
}
variable "name" {
  description = "Название сервиса, оно используется в качестве тега"
}
variable "env" {
  type        = string
  description = "Окружение"
}
