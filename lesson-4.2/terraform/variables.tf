variable "project" {
  type        = string
  description = "Project ID"
}
variable "credentials" {
  type    = string
  description = "Данные для подключения к GCP"
  sensitive   = true
}
variable "vm_name" {
  type    = string
  description = "Название сервера"
  default     = "vm"
}
variable "zone" {
  type    = string
  description = "Регион расположения сервера"
  default     = "europe-west10-a"
}
variable "username" {
  type    = string
  description = "Имя пользователя для подключения"
}
variable "firewall_filter" {
  description = "Фильтр ip адресов"
  default     = ["0.0.0.0/0"]
}
variable "private_key_path" {
  description = "Путь к приватному ssh-ключу"
}
