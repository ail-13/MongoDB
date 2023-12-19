# Ansible Role: mongodb

Устанавливает на сервер MongoDB и Percona Backup for MongoDB. Монтирует к дирректории отдельный диск для хранения базы данных и если диск пустой, то форматирует его в XFS. Запускает MongoDB в режиме replica set (если уже существует replica set с другим названием, то будет ошибка). Создает пользователей root, beckup и user для доступа к базе данных. При изменении имени или пароля для пользователей конфигурация серверов будет изменена.

## Requirements

Тестировалась только на Ubuntu

## Role Variables

Значения по умолчанию хранятся в файле `defaults/main.yml`.

    mongodb_data_path: /db
    mongodb_port: 27017
    mongodb_version: 4.4
    mongodb_keyfile: ~/.keyfile
    mongodb_rs_name: rs0
    mongodb_root_name: root
    mongodb_user_name: user
    mongodb_percona_name: percona
    mongodb_percona_version: latest

В параметре `vm_disk` содержится название диска который убедт монтироваться для хранения файлов базы данных

В параметре `vm_username` содержится имя пользователя виртуальной машины от которого будет происходить установка

В параметре `mongodb_data_path` указывается путь к папке в которой будут хранится файлы базы данных. Папка не создается автоматически и должна существовать, иначе будет ошибка.

В параметрах `mongodb_root_name`, `mongodb_root_pass`, `mongodb_user_name`, `mongodb_user_pass`, `mongodb_percona_name` и `mongodb_percona_pass` содержатся данные пользователей которые будут созданы при создании базы. Если база уже существует, то эти параметры игнорируются.

В параметре `mongodb_version` содержится версия MongoDB которая будет запущена.

В параметре `mongodb_port` указывается порт который будет проброшен из контейнера с MongoDB наружу в хостовоую систему. Внутри контейнера MongoDB работает на 27017 порту

В параметре `mongodb_keyfile` указывается путь к файлу ключа который будет использоваться для авторизации в кластере MongoDB

В параметре `mongodb_rs_name` указывается название replica set

В параметре `mongodb_percona_version` указывается версия Percona Backup for MongoDB

## Example Playbook

      hosts: db
      become: true
      roles:
        - role: mongodb
          vars:
            vm_disk: mongo-disk
            vm_username: mongo_user
            mongodb_root_pass: mongo123
            mongodb_user_pass: mongo123
            mongodb_percona_pass: mongo123
            mongodb_data_path: /db
            mongodb_port: 27001

## License

All Rights Reserved

## Author Information

ail-13
