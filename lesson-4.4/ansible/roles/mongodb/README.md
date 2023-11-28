# Ansible Role: mongodb

Устанавливает на сервер Docker, docker-compose и dive. Монтирует к дирректории отдельный диск для хранения базы данных и если диск пустой, то форматирует его в XFS. Через docker-compose запускает на сервере MongoDB в контейнере созданном из официального образа

## Requirements

Тестировалась только на Ubuntu

## Role Variables

Значения по умолчанию хранятся в файле `defaults/main.yml`.

    mongodb_data_path: /db
    mongodb_port: 27017
    mongodb_version: 4.4

В параметре `vm_disk` содержится название диска который убедт монтироваться для хранения файлов базы данных

В параметре `vm_username` содержится имя пользователя виртуальной машины от которого будет происходить установка

В параметре `mongodb_data_path` указывается путь к папке в которой будут хранится файлы базы данных. Папка не создается автоматически и должна существовать, иначе будет ошибка.

В параметрах `mongodb_user_name` и `mongodb_user_pass` содержатся данные пользователя который будет создан при создании базы. Если база уже существует, то эти параметры игнорируются.

В параметре `mongodb_version` содержится версия MongoDB которая будет запущена.

В параметре `mongodb_port` указывается порт который будет проброшен из контейнера с MongoDB наружу в хостовоую систему. Внутри контейнера MongoDB работает на 27017 порту

## Global Variables

В глобальных переменных 

## Dependencies

geerlingguy.docker

## Example Playbook

      hosts: db
      become: true
      roles:
        - role: mongodb
          vars:
            vm_disk: mongo-disk
            vm_username: mongo_user
            mongodb_user_name: root
            mongodb_user_pass: mongo123
            mongodb_data_path: /db
            mongodb_port: 27001

## License

All Rights Reserved

## Author Information

ail-13
