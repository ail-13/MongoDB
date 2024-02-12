output "kubernetes_cluster_host" {
  value       = module.k8s.kubernetes_cluster_host
  description = "IP адрес кластера"
}

output "kubernetes_cluster_name" {
  value       = module.k8s.kubernetes_cluster_name
  description = "Название кластера"
}

output "connection_command" {
  value = "gcloud container clusters get-credentials ${module.k8s.kubernetes_cluster_name} --zone ${var.zone} --project ${var.project}"
  description = "Команда для подключения к кластеру Kubernetes"
}