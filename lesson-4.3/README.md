# Установка MongoDB в Docker с помошью ролей Ansible

Весь процесс разбит на три этапа

1. Создание и конфигурирование виртуального сервера
1. Запуск на сервере роли `mongodb`. Плейбук `./ansible/db.yml`
1. Запуск на сервере роли `app`. Плейбук `./ansible/app.yml`

## Запуск
1. Создаем файл конфигурации для Terraform `./terraform/terraform.tfvars`

        project          = "GCP_project_name"
        username         = "mongo_user"
        private_key_path = "~/.ssh/mongo_user"
        vm_name          = "lesson-4.3"

1. Разворачиваем все необходимые ресурсы через Terraform, после завершения Terraform выдаст ip адрес созданного сервера

        cd ./terraform
        terraform init
        terraform apply

1. Запускаем плейбук Ansible с ролью `mongodb`, она установит все необходимые компоненты и создаст контейнер с запущенной MongoDB

        cd ./ansible
        ansible-playbook db.yml

1. Запускаем плейбук Ansible с ролью `app`, она установит все необходимые компоненты и контейнер с клиентом. Контейнер подключится к базе `test` и в коллекции `notes` создаст несколько записей

        cd ./ansible
        ansible-playbook app.yml

1. По ip адреу который выдал Terraform на предыдущем шаге можно будет подключиться к базе

        mongo mongodb://root:mongo123@x.x.x.x:27001
        mongosh x.x.x.x:27001 -u root -p mongo123
        mongodb://root:mongo123@x.x.x.x:27001

## Примечание
С Ansible нельзя работать из под Windows, поэтому вся работа с проектом происходит в WSL. На WSL необходимо установить Ubuntu, установить Python и Ansible

## Примечание
Нужно сгенерировать ключ для подключения, этот сгенерированный ключ указывается в private_key_path в значениях переменных Terraform и будет добавлен всем серверам

    ssh-keygen -t rsa -f ~/.ssh/mongo_user -N "" -C "mongo_user"

Также можно вручную добавить ключ в Compute Engine -> Settings -> Metadata, тогда он добавится во все машины и его можно будет использовать для подключения

## Примечание
Для подключения к GCP необходимо создать сервисный аккаунт и создать для него приватный ключ, будет сгенерирован JSON файл который нужно будет положить в папку `./terraform/credentials.json`

https://console.cloud.google.com/iam-admin/serviceaccounts

Либо можно выполнить авторизацию с рабочей машины командой (тогда параметр credentials можно удалить)

    gcloud auth application-default login --no-launch-browser

## Примечание
У файла динамического инвентори `./ansible/inventory.sh` должны быть права на выполнение

    chmod +x inventory.sh

## Примечание
В файле packer.json находится шаблон для Packer с описанием образа виртуальной машины с установленной MongoDB. Этот образ можно будет использовать при создании виртуальных машин

        packer validate packer.json
        packer build packer.json