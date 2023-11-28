# Установка MongoDB в Docker с помошью ролей Ansible

В данной кофигурации добавлены два окружения `stage` и `prod`. Для каждого окружения описана конфигурация для Terraform и для Ansible. Команды Terraform должны выполняться из соответствующих папок `./terraform/stage/` и `./terraform/prod/`. Плейбуки Ansible запускаются из папки `./ansible`, по умолчанию все плейбуки выполняются для `stage` инвентори.

Переменные окружения были разнесены для каждого окружения и для каждого хоста

Пароли используемые в Ansible были спрятаны в секретах. Для работы с секретами необходимо добавить файл `~/.ansible/vault.key` с паролем.

Весь процесс разбит на два этапа:

1. Создание и конфигурирование виртуальных сервера
1. Запуск ролей для созданных серверов

## Запуск
1. Создаем файл конфигурации для Terraform `./terraform/stage/terraform.tfvars`

        project          = "GCP_project_name"
        username         = "mongo_user"
        private_key_path = "~/.ssh/mongo_user"
        project_name     = "lesson-4.4"

1. Разворачиваем все необходимые ресурсы через Terraform, после завершения Terraform выдаст ip адрес созданного сервера

        cd ./terraform/stage
        terraform init
        terraform apply

1. Создаем файлы с паролями

        cd ./ansible
        nano ./environments/stage/group_vars/app/secrets.yml

        app_db_username: root
        app_db_pass: mongo123

        nano ./environments/stage/group_vars/db/secrets.yml

        mongodb_user_name: root
        mongodb_user_pass: mongo123

1. Шифруем файлы

        ansible-vault encrypt ./environments/stage/group_vars/app/secrets.yml
        ansible-vault encrypt ./environments/stage/group_vars/db/secrets.yml

1. Перед запуском плейбуков необходимо установить зависимости для окружения

        ansible-galaxy install -r ./environments/stage/requirements.yml

1. Запускаем плейбук для сервера с MongoDB, он установит все необходимые компоненты и создадут контейнер с базой. По умолчанию все плейбуки выполняются на stage окружении.

        ansible-playbook ./playbooks/db.yml

1. Запускаем плейбук для сервера с приложением, он установит все необходимые компоненты и создадут контейнер с клиентом. Клиент подключится к базе test и в коллекции notes создаст несколько записей.

        ansible-playbook ./playbooks/app.yml

1. По ip адреу который выдал Terraform на втором шаге можно будет подключиться к базе

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
Для подключения к GCP необходимо создать сервисный аккаунт и создать для него приватный ключ, будет сгенерирован JSON файл который нужно будет положить в `./terraform/credentials.json`

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

## Примечание
Чтобы запустить плейбук на prod окружении нужно указать его инвентори

    ansible-playbook -i ./environments/prod/inventory.sh playbooks/app.yml

Список хостов окружения можно посмотреть через динамический инвентори

    ./environments/prod/inventory.sh --list

## Примечание
Чтобы расшифроват файл с секретами нужно выполнить команду

    ansible-vault decrypt ./environments/stage/group_vars/db/secrets.yml

Для едактирование секретов без расшифровки нужно выполнить команду

    ansible-vault edit ./environments/stage/group_vars/db/secrets.yml

Если редактирование открывается в vim, то нужно изменить редактор по умолчанию на nano

    echo 'export EDITOR=nano' >> ~/.bashrc && source ~/.bashrc