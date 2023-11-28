#!/bin/bash

# Переходим на уровень вверх, т.к. файлы Terraform находятся там
cd ..
# Запускаем terraform output и извлекаем IP-адрес и имя пользователя
mongodb_ip=$(terraform output -state=./terraform/prod/terraform.tfstate -raw mongodb_ip)
mongodb_user=$(terraform output -state=./terraform/prod/terraform.tfstate -raw mongodb_user)
mongodb_disk=$(terraform output -state=./terraform/prod/terraform.tfstate -raw mongodb_disk)
app_ip=$(terraform output -state=./terraform/prod/terraform.tfstate -raw app_ip)

# Создаем динамический инвентарь Ansible в формате JSON
if [ "$1" == "--list" ]; then
cat << EOF
{
  "_meta": {
    "hostvars": {
      "db_server": {
        "ansible_host": "$mongodb_ip",
        "vm_username": "$mongodb_user",
        "vm_disk": "$mongodb_disk"
      },
      "app_server": {
        "ansible_host": "$app_ip",
        "mongodb_ip": "$mongodb_ip",
        "vm_username": "$mongodb_user"
      }
    }
  },
  "db": {
    "hosts": [
        "db_server"
    ]
  },
  "app": {
    "hosts": [
        "app_server"
    ]
  }
}
EOF
elif [ "$1" == "--host" ]; then
  echo '{"_meta": {hostvars": {}}}'
else
  echo "{ }"
fi