# Ansible Role: monitoring

Устанавливает на сервер Percona Monitoring and Management

## Requirements

Тестировалась только на Ubuntu

## Role Variables

Значения по умолчанию хранятся в файле `defaults/main.yml`.

    monitoring_percona_version: latest
    monitoring_percona_force_config: false
    monitoring_data_path: /monitoring_data
    monitoring_backup_prefix: test
    monitoring_mongodb_user: backup
    monitoring_mongodb_port: 27017
    monitoring_mongodb_rs_name: rs0

В параметре `monitoring_percona_version` указывается версия Percona Monitoring and Management.

В параметре `monitoring_percona_force_config` указывается необходимость принудительно перезаписи конфигурационных файлов.

В параметре `monitoring_data_path` указывается путь к папке в которой будут хранится данные мониторинга.

В параметре `monitoring_password` содержется пароль для входа в панель мониторинга.

В параметре `monitoring_backup_prefix` указывается префикс для названия бакета в котором будут хранится бекапы.

В параметре `monitoring_mongodb_user` указывается имя пользователя для подключения к базе данных.

В параметре `monitoring_mongodb_pass` указывается пароль для подключения к базе данных.

В параметре `monitoring_mongodb_port` указывается порт на котором работает база данных.

В параметре `monitoring_mongodb_rs_name` указывается имя репликации.

В параметрах `monitoring_backup_bucket`, `monitoring_backup_access_key` и `monitoring_backup_secret_key` указываются данные для подключения к S3 бакету в котором будут хранится бекапы

## Example Playbook

      hosts: db
      become: true
      roles:
        - role: monitoring
          vars:
            monitoring_password: 12345678
            monitoring_mongodb_user: backup
            monitoring_mongodb_pass: mongo123
            monitoring_backup_bucket: backup
            monitoring_backup_access_key: xxxxxxxxxxxxxxx
            monitoring_backup_secret_key: xxxxxxxxxxxxxxx

## License

All Rights Reserved

## Author Information

ail-13
