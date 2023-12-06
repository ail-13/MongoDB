#!/bin/bash

# Переходим на уровень вверх, т.к. файлы Terraform находятся там
cd ..
# Запускаем terraform output и извлекаем сформированный ивентори
inventory=$(terraform output -state=./terraform/stage/terraform.tfstate -json inventory)

# Создаем динамический инвентарь Ansible в формате JSON
if [ "$1" == "--list" ]; then
  echo "$inventory"
elif [ "$1" == "--host" ]; then
  echo '{"_meta": {hostvars": {}}}'
else
  echo "{ }"
fi