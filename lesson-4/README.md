# Установка MongoDB в Docker

Весь процесс разбит не несколько этапов:

1. Создание и конфигурирование виртуального сервера (происходит так же как в lesson-3)
1. Установка Docker и dive. Процесс установки описан в фалйе `./scripts/docker_install.sh`
1. Создание образов контейнеров и запуск контейнеров. Процесс описан в файле `./scripts/docker_container.sh`

## Запуск
1. Создаем файл конфигурации для Terraform `terraform.tfvars`

        project         = "GCP_project_name"
        username        = "mongo_user"
        public_key_path = "C:\\data\\keys\\mongo"
        vm_name         = "lesson-4"

1. Разворачиваем все необходимые ресурсы через Terraform

        terraform init
        terraform apply

1. Terraform создаст контейнер с базой и контейнер с клиентом. Контейнер с клиентом подключится к базе test и в коллекции notes создаст записей. После выполнения всех действий Terraform выдаст ip адрес созданного сервера, по нему можно будет подключиться к базе

        mongo mongodb://root:mongo123@x.x.x.x:27001
        mongosh x.x.x.x:27001 -u root -p mongo123
        mongodb://root:mongo123@x.x.x.x:27001

1. Можно удалить контейнер и создать его заново чтобы убедиться что созданные в базе записи остались на месте

        docker stop dobgodb
        docker rm dobgodb
        docker run --name mongodb -p 27001:27001 -v /db:/db --network mongo-network -d mongodb:7.0

## Примечание
Параметры контейнера с MongoDB содержатся в папке `./files/db`, параметры контейнера с клиентом в файле `./files/client`

## Примечание
Для удобной работы с Docker на Visual Studion Code нужно установить расширение Docker