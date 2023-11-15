#!/bin/bash
set -e

# Скачиваем и конвертируем в GPG открытый ключ MongoDB
# https://habr.com/ru/articles/683716/
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
# Добавляем ссылку на репозиторий
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
# Обновляем репозитории
sudo apt-get update
# Устанавливаем MongoDB
sudo apt-get install -y mongodb-org
# Заменяем файл конфигурации MongoDB
sudo cp /tmp/mongod.conf /etc/mongod.conf
rm /tmp/mongod.conf
# Прописываем доступ к каталогу с данными для пользователя mongodb
sudo chown -R mongodb:mongodb /db
# Запускаем MongoDB
sudo systemctl start mongod
# Добавляем MongoDB в автозапуск
sudo systemctl enable mongod

# Создаем пользователя для подключения
mongosh admin --port 27001 --eval "db.createUser( { user: 'root', pwd: 'mongo123', roles: [ 'userAdminAnyDatabase', 'dbAdminAnyDatabase', 'readWriteAnyDatabase' ] } );"