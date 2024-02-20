## Настройка Google Cloud Platform
Для запуска проекта необходимо выполнить следующие шаги:

1. Создать проект в GCP
1. Открыть доступ `Compute Engine API` к API для проекта
1. Создать ключ для сервисного аккаунта в формате JSON, скачать его и положить в файл `terraform/credentials.json`

        IAM & Admin -> Service accounts -> <service accaunt> -> Keys -> Add key -> Create new key -> JSON

1. Создаем файл конфигурации для Terraform `./terraform/dev/terraform.tfvars`. ВАЖНО: количество серверов с базой данных должно быть нечетным, так как MongoDB требует нечетное количество серверов для репликации
1. Разворачиваем все необходимые ресурсы

        cd ./terraform/dev
        terraform init
        terraform apply

1. После выполнения команды `terraform apply` Terraform выведет ip адреса созданных серверов. Значение `hosts` нужно будет добавить в файл `C:\Windows\System32\drivers\etc\hosts` чтобы можно подключиться к replicaset MongoDB

## Запуск Ansible
1. Задаем настройки

        nano ./environments/dev/group_vars/all/main.yml
        nano ./environments/dev/group_vars/app/main.yml
        nano ./environments/dev/group_vars/db/main.yml
        nano ./environments/dev/group_vars/monitoring/main.yml

1. Шифруем файлы с секретами

        ansible-vault encrypt ./environments/dev/group_vars/all/secrets.yml
        ansible-vault encrypt ./environments/dev/group_vars/app/secrets.yml
        ansible-vault encrypt ./environments/dev/group_vars/db/secrets.yml
        ansible-vault encrypt ./environments/dev/group_vars/monitoring/secrets.yml

1. Запускаем плейбук Ansible, он установит все необходимые компоненты

        ansible-playbook ./playbooks/main.yml

1. По ip адреу который выдал Terraform на втором шаге можно будет подключиться к базе

        mongo mongodb://root:mongo123@x.x.x.x:27017
        mongosh x.x.x.x:27017 -u root -p mongo123
        mongodb://root:mongo123@x.x.x.x:27017

1. По ip адреу который выдал Terraform на втором шаге можно будет подключиться к панели мониторинга

        https://x.x.x.x
