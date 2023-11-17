variable "source_ranges" {
  description = "Разрешенные ip-адреса"
  default     = ["0.0.0.0/0"]
}
variable "name" {
  description = "Название сервера, оно используется в качестве тега"
}
