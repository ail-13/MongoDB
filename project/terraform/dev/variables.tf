variable "vm_username" {
  type        = string
  description = "Имя пользователя который будет создан на серверах"
}
variable "public_key_path" {
  type        = string
  description = "Путь к публичному ssh-ключу"
}
variable "project" {
  type        = string
  description = "Название проекта в GCP"
}
variable "zone" {
  type        = string
  description = "Датацентр GCP"
}
variable "region" {
  type        = string
  description = "Датацентр GCP"
}
