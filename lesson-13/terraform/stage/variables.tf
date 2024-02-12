variable "project" {
  type        = string
  description = "Project ID"
}
variable "project_name" {
  type        = string
  description = "Название сервиса"
}
variable "zone" {
  type        = string
  description = "Регион расположения сервера"
}
variable "worker_count" {
  type        = number
  description = "Количество worker нод"
}
