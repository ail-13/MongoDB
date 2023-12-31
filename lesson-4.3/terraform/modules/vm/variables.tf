variable "vm_name" {
  description = "Название сервера"
  default     = "vm"
}
variable "zone" {
  description = "Регион расположения сервера"
  default     = "europe-west10-a"
}
variable "username" {
  description = "Имя пользователя для подключения"
}
variable "private_key_path" {
  description = "Путь к публичному ssh-ключу"
}
