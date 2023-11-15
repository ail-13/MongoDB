# Установка MongoDB

Установка будет осуществляться на виртуальный сервер в Google Cloud Platform. Будет создана одна виртуальная машина и отдельный диск для хранения базы данных. Для этого нужно в GCP создать новый проект и прописать ssh-ключ для управления созданным проектом.


1. Для подключения к GCP генерируем ключ через PuTTY Key Generator или через консоль:

        ssh-keygen -t rsa -C mongo_user -f C:\\data\\keys\\mongo -P 1234
    

1. Вставляем сгенерированный публичный ключ в GCP

        Compute Engine -> Settings -> Metadata -> SSH KEYS

1. Для подключения к созданному серверу нужно добавить сгенерированный ключ в Pagent. Если ключ был сгенерирован через PuTTY Key Generator, то просто добавляем его в Pagent. Если нет, то нужно импортировать приватный ключ в PuTTY Key Generator и сохранить его в формате ppk. А после этого доавить в Pagent

        Conversions -> Import key -> Save private key

1. Разворачиваем все необходимые ресурсы через Terraform

        terraform init
        terraform apply

1. После завершения Terraform выдаст ip адрес созданного сервера и можно будет подключиться к MongoDB

        mongo mongodb://root:mongo123@x.x.x.x:27001
        mongosh x.x.x.x:27001 -u root -p mongo123
        mongodb://root:mongo123@x.x.x.x:27001

## Примечание
Процесс установки MongoDB описан в файле `./files/mongo_install.sh`, конфигурация MongoDB прописана в файле `./files/mongod.conf` 