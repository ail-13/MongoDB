# Ansible Role: app

Устанавливает на сервер Docker, docker-compose и dive. Через docker-compose запускает не сервере приложение в контейнере

## Requirements

Тестировалась только на Ubuntu

## Role Variables

Значения по умолчанию хранятся в файле `defaults/main.yml`.

    app_db_port: 27017
    app_path: app/

В параметрах `app_db_host` и `app_db_port` содержатся адрес базы данных и порт для подключения.

В параметрах `app_db_username` и `app_db_pass` содержатся данные пользователя для подключения к базе данных.

В параметре `app_path` содержится путь к папке с приложением, путь относительно плейбука

## Dependencies

geerlingguy.docker

## Example Playbook

      hosts: db
      become: true
      roles:
        - role: app
          vars:
            app_db_username: root
            app_db_pass: mongo123
            app_db_host: 111.111.111.111
            app_db_port: 27001
            app_path: app/

## License

All Rights Reserved

## Author Information

ail-13
