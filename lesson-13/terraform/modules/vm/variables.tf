variable "vm_name" {
  type        = string
  description = "Название сервера"
}
variable "zone" {
  type        = string
  description = "Регион расположения сервера"
}
variable "username" {
  type        = string
  description = "Имя пользователя для подключения"
}
variable "private_key_path" {
  type        = string
  description = "Путь к публичному ssh-ключу"
}
variable "create_disk" {
  type        = bool
  description = "Создать дополнительный диск на сервере"
}
variable "env" {
  type        = string
  description = "Окружение"
}
variable "vm_count" {
  type        = number
  description = "Количество создаваемых серверов"
}
