# Разворачиваем реплицированный кластер MongoDB

Будет создан реплицированный кластер MongoDB c резервным копированием в Google Cloud Storage. Для подключения к базе данных будет созданы пользователи root, backup и user. Все настройки будут производиться через Ansible.

Весь процесс состоит из нескольких этапов:

1. Создание виртуальных машин
1. Запуск роли Ansible которая установит MongoDB, настроит репликацию и бекап

## Запуск
1. Создаем файл конфигурации для Terraform `./terraform/stage/terraform.tfvars`. Количество серверов с базой данных `db_count` должно быть нечетным, так как MongoDB требует нечетное количество серверов для репликации

        project          = "GCP_project_name"
        username         = "mongo_user"
        private_key_path = "~/.ssh/mongo_user"
        project_name     = "lesson-9"
        app_count        = 1
        db_count         = 3

1. Разворачиваем все необходимые ресурсы через Terraform, после завершения Terraform выдаст ip адреса созданных серверов

        cd ./terraform/stage
        terraform init
        terraform apply

1. Создаем файлы с паролями

        cd ./ansible
        nano ./environments/stage/group_vars/app/secrets.yml

        app_db_username: root
        app_db_pass:     mongo123

        nano ./environments/stage/group_vars/db/secrets.yml

        mongodb_user_pass: mongo123
        mongodb_root_pass: mongo123
        mongodb_backup_pass: mongo123
        mongodb_backup_bucket: backup
        mongodb_backup_access_key: xxxxxxxxxxxxxxx
        mongodb_backup_secret_key: xxxxxxxxxxxxxxx

1. Шифруем файлы

        ansible-vault encrypt ./environments/stage/group_vars/app/secrets.yml
        ansible-vault encrypt ./environments/stage/group_vars/db/secrets.yml

1. Перед запуском плейбуков необходимо установить зависимости для окружения

        ansible-galaxy install -r ./environments/stage/requirements.yml

1. Запускаем плейбук для хостов db, он установит MongoDB и все необходимые компоненты. По умолчанию все плейбуки выполняются на stage окружении.

        ansible-playbook ./playbooks/db.yml

1. Запускаем плейбук для сервера с приложением, он установит все необходимые компоненты и создадут контейнер с клиентом. Клиент подключится к базе test и в коллекции notes создаст несколько записей.

        ansible-playbook ./playbooks/app.yml

1. По ip адреу который выдал Terraform на втором шаге можно будет подключиться к базе

        mongo mongodb://root:mongo123@x.x.x.x:27001
        mongosh x.x.x.x:27001 -u root -p mongo123
        mongodb://root:mongo123@x.x.x.x:27001

## Примечание
С Ansible нельзя работать из под Windows, поэтому вся работа с проектом происходит в WSL. На WSL необходимо установить Ubuntu, установить Python и Ansible. Для тестов необходимо установить PowerShell последней версии из Microsoft Store

## Примечание
Нужно сгенерировать ключ для подключения, этот сгенерированный ключ указывается в private_key_path в значениях переменных Terraform и будет добавлен всем серверам

    ssh-keygen -t rsa -f ~/.ssh/mongo_user -N "" -C "mongo_user"

Также можно вручную добавить ключ в Compute Engine -> Settings -> Metadata, тогда он добавится во все машины и его можно будет использовать для подключения

## Примечание
Для подключения к GCP при создании проекта необходимо включить Compute Engine API, GCP создаст сервисный аккаунт. В созданном сервисном аккаунте нужно создать приватный ключ, будет сгенерирован JSON файл который нужно будет положить в `./terraform/credentials.json`

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
Чтобы расшифровать файл с секретами нужно выполнить команду

    ansible-vault decrypt ./environments/stage/group_vars/db/secrets.yml

Для редактирования секретов без расшифровки нужно выполнить команду

    ansible-vault edit ./environments/stage/group_vars/db/secrets.yml

Если редактирование открывается в vim, то нужно изменить редактор по умолчанию на nano

    echo 'export EDITOR=nano' >> ~/.bashrc && source ~/.bashrc

## Примечание
Сгенерировать ключ для MongoDB можно командой

    openssl rand -base64 756 > ~/.mongokey

## Полезные ссылки
Описание модуля mongodb_replicaset

https://ansible-collections.github.io/community.mongodb/mongodb_replicaset.html


## Примечание
Для создания бекапов в GCP необходимо выполнить следующие действия:
1. Создать бакет в GCP для хранения бекапов

        Cloud Storage -> Backets -> Create

1. Создать ключ для доступа к бакету

        Cloud Storage -> Settings -> Interoperability -> Create a key


## Примечание
Настроено автоматическое создание бекапов в Google Cloud Storage. Бекапы создаются каждый день в 00:00 по UTC. Для восстановления из бекапа нужно выполнить команду

    pbm restore <name>

Для ручного создания бекапа нужно выполнить команду

    pbm backup