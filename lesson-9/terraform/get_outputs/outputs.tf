# Вывводим значение поля state считанного из облака
output "mongo_ip" {
  value = data.terraform_remote_state.infra.outputs.inventory.db
}
