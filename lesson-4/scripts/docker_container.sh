#!/bin/bash
set -e

# Создаем образы и запускаем контейнеры
# Создаем образ с MongoDB
docker build -t mongodb:7.0 /tmp/db
# Создаем образ с клиента
docker build -t node:14 /tmp/client

# Создаем сеть для подключения контейнеров. Это нужно для того чтобы можно было обращаться к контейнерам по имени,
# по умолчанию контейнеры подключаются к сети bridge которая использует только ip адреса и не допускает использование имен
docker network create mongo-network

# Запускаем контейнер с MongoDB
docker run --name mongodb -p 27001:27001 -v /db:/db --network mongo-network -d mongodb:7.0
# Проверяем, запустился ли контейнер и MongoDB
while ! docker exec -it mongodb mongosh --port 27001 --eval "quit(db.runCommand({ ping: 1 }).ok ? 0 : 2)" &> /dev/null; do
    echo "Ждем запуска контейнера MongoDB..."
    sleep 2
done
# Создаем пользователя для подключения
docker exec -it mongodb mongosh admin --port 27001 --eval "db.createUser( { user: 'root', pwd: 'mongo123', roles: [ 'userAdminAnyDatabase', 'dbAdminAnyDatabase', 'readWriteAnyDatabase' ] } );"

# Запускаем контейнер с клиентом
docker run --name client --network mongo-network -d node:14