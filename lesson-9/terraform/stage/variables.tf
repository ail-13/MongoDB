variable "project" {
  type        = string
  description = "Project ID"
}
variable "credentials" {
  type        = string
  description = "Данные для подключения к GCP"
  sensitive   = true
}
variable "project_name" {
  type        = string
  description = "Название сервиса"
  default     = "vm"
}
variable "zone" {
  type        = string
  description = "Регион расположения сервера"
  default     = "europe-west10-a"
}
variable "username" {
  type        = string
  description = "Имя пользователя для подключения"
}
variable "private_key_path" {
  type        = string
  description = "Путь к приватному ssh-ключу"
}
variable "app_count" {
  type        = number
  description = "Количество серверов с приложением"
  default     = 1
}
variable "db_count" {
  type        = number
  description = "Количество серверов с базой данных"
  default     = 3
}
variable "mongodb_port" {
  type        = number
  description = "Порт MongoDB"
  default     = 27017
}
variable "mongodb_source_ranges" {
  type        = list(string)
  description = "Фильтр внешних ip адресов для подключения к MongoDB"
  default     = []
}
variable "monitoring_source_ranges" {
  type        = list(string)
  description = "Фильтр ip адресов для подключения к мониторингу"
  default     = ["0.0.0.0/0"]
}
