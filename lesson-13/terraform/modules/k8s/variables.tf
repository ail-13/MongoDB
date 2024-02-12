variable "name" {
  type        = string
  description = "Название кластера"
}
variable "zone" {
  type        = string
  description = "Регион расположения кластера"
}
variable "env" {
  type        = string
  description = "Окружение"
}
variable "worker_count" {
  type        = number
  description = "Количество worker нод"
}
