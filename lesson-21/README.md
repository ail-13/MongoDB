# Установка MongoDB в облаке
Установка MongoDB будет производиться в облаке Yandex.Cloud. Для разворачивания кластера необходимо выполнить следующие шаги:

1. Переходим в раздел `Managed Service for MongoDB` -> `Кластеры` -> `Создать кластер`
1. Выбираем параметры кластера:
    - Имя кластера: `rs01`
    - Окружение: `PRODUCTION`
    - Версия: `5.0`
    - Тип: `s3-c2-m8`
    - Размер хранилища: `10 ГБ`
    - Имя БД: `db1`
    - Имя пользователя: `user`
    - Пароль: `password`
    - Сеть: `default`
    - Открываем публичный доступ для хостов
1. После создания кластера переходим в раздел `Кластеры` -> `rs01` -> `Подключиться`
1. Выбираем `Bash` и копируем команды подключения

        mkdir -p ~/.mongodb && \
        wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" \
            --output-document ~/.mongodb/root.crt && \
        chmod 0644 ~/.mongodb/root.crt

        mongosh --norc \
            --tls \
            --tlsCAFile ~/.mongodb/root.crt \
            --host 'rs01/xxxxxxxxxxxxxxx.mdb.yandexcloud.net:27018,yyyyyyyyyyyyyyy.mdb.yandexcloud.net:27018,zzzzzzzzzzzzzzz.mdb.yandexcloud.net:27018' \
            --username user \
            --password password \
            db1


## Установка `mongosh`

        curl -fsSL https://www.mongodb.org/static/pgp/server-5.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-5.0.gpg --dearmor
        echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-5.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
        sudo apt-get update
        sudo apt-get install -y mongodb-mongosh