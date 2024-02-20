#!/bin/bash

# Переходим в папку Terraform для окружения stage
cd ../terraform/dev

# Запускаем terraform output и извлекаем сформированный ивентори
inventory=$(terraform output -json inventory)

# Создаем динамический инвентарь Ansible в формате JSON
if [ "$1" == "--list" ]; then
  echo "$inventory"
elif [ "$1" == "--host" ]; then
  echo '{"_meta": {hostvars": {}}}'
else
  echo "{ }"
fi