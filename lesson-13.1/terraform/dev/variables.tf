variable "vm_username" {
  type        = string
  description = "Имя пользователя который будет создан на серверах"
}
variable "public_key_path" {
  type        = string
  description = "Путь к публичному ssh-ключу"
}
variable "gcp_project" {
  type        = string
  description = "Название проекта в GCP"
}
variable "gcp_vdc_g" {
  type = object({
    zone   = string
    alias  = string
    region = string
  })
  description = "Датацентр GCP"
}
