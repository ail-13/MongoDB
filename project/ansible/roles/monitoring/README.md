# Ansible Role: monitoring

Устанавливает на сервер Percona Monitoring and Management и Percana Backup for MongoDB

## Requirements

Тестировалась только на Ubuntu

## Role Variables

Значения по умолчанию хранятся в файле `defaults/main.yml`.

    monitoring_percona_version: latest
    monitoring_percona_force_config: false
    monitoring_data_path: /monitoring_data
    monitoring_mongodb_user: percona
    monitoring_mongodb_port: 27017
    monitoring_mongodb_rs_name: rs0

В параметре `vm_disk` содержится название диска который убедт монтироваться для хранения файлов базы данных. Если параметр не указан, то данные будут хранится на системном диске.

В параметре `monitoring_mongodb_ip` указывается массив IP адресов серверов с MongoDB.

В параметре `monitoring_percona_version` указывается версия Percona Monitoring and Management.

В параметре `monitoring_percona_force_config` указывается необходимость принудительно перезаписи конфигурационных файлов.

В параметре `monitoring_data_path` указывается путь к папке в которой будут хранится данные мониторинга.

В параметре `monitoring_password` содержется пароль для входа в панель мониторинга.

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
            monitoring_mongodb_pass: mongo123
            monitoring_backup_bucket: backup_ls
            monitoring_backup_access_key: GOOG2RWJDEUU7D3QBTEOYY6G
            monitoring_backup_secret_key: /ZoZr7jawxvw6CFPQKiJbx6zvHcRdDtn/JFeMCxV
            monitoring_password: 12345678
            monitoring_mongodb_ip: [xxx.xxx.xxx.xxx, xxx.xxx.xxx.xxx]

## License

All Rights Reserved

## Author Information

ail-13
