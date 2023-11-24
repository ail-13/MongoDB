#!/bin/bash

# Переходим на уровень вверх, т.к. файлы Terraform находятся там
cd ..
# Запускаем terraform output и извлекаем IP-адрес и имя пользователя
mongodb_ip=$(terraform output -state=./terraform/terraform.tfstate -raw mongodb_ip)
mongodb_user=$(terraform output -state=./terraform/terraform.tfstate -raw mongodb_user)

# Создаем динамический инвентарь Ansible в формате JSON
if [ "$1" == "--list" ]; then
cat << EOF
{
  "_meta": {
    "hostvars": {
      "dbserver": {
        "ansible_host": "$mongodb_ip",
        "vm_username": "$mongodb_user"
      }
    }
  },
  "db": {
    "hosts": [
        "dbserver"
    ]
  }
}
EOF
elif [ "$1" == "--host" ]; then
  echo '{"_meta": {hostvars": {}}}'
else
  echo "{ }"
fi