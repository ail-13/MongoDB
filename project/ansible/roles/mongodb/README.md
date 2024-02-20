# Ansible Role: mongodb

Устанавливает на сервер MongoDB и Percona Backup for MongoDB. Монтирует к дирректории отдельный диск для хранения базы данных и если диск пустой, то форматирует его в XFS. Запускает MongoDB в режиме replica set. Создает пользователей root, beckup и user для доступа к базе данных. При изменении имени или пароля для пользователей конфигурация серверов будет изменена.

ВАЖНО: если какой-то из серверов уже подключен к кластеру replica set, то никаких изменений не произойдет.

ВАЖНО: доступ к MongoDB открывается только со 127.0.0.1 и с ip адресов указанных в переменной `vm_internal_ip`

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

В параметре `vm_disk` содержится название диска который убедт монтироваться для хранения файлов базы данных. Если параметр не указан, то данные будут хранится на системном диске.

В параметре `vm_internal_ip` содержится список ip адресов с которых будет доступна база данных

В параметре `mongodb_data_path` указывается путь к папке в которой будут хранится файлы базы данных. Папка не создается автоматически и должна существовать, иначе будет ошибка.

В параметрах `mongodb_root_name`, `mongodb_root_pass`, `mongodb_user_name`, `mongodb_user_pass`, `mongodb_percona_name`, `mongodb_percona_pass`, содержатся данные пользователей которые будут созданы при создании базы. Если база уже существует, то эти параметры игнорируются.

В параметре `mongodb_version` содержится версия MongoDB которая будет запущена.

В параметре `mongodb_port` указывается порт котором будет запущена MongoDB.

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
            mongodb_root_pass: mongo123
            mongodb_user_pass: mongo123
            mongodb_percona_pass: mongo123
            mongodb_data_path: /db
            mongodb_port: 27001

## License

All Rights Reserved

## Author Information

ail-13
