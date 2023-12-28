# Ansible Role: ppm_client

Устанавливает и настраивает Percona Monitoring and Management Client

## Requirements

Тестировалась только на Ubuntu

## Role Variables

Значения по умолчанию хранятся в файле `defaults/main.yml`.

    pmm_client_mongodb_port: 27017
    pmm_client_mongodb_rs_name: rs0
    pmm_client_mongodb_percona_name: percona

В параметре `pmm_client_mongodb_port` указывается порт который будет проброшен из контейнера с MongoDB наружу в хостовоую систему. Внутри контейнера MongoDB работает на 27017 порту

В параметре `pmm_client_mongodb_rs_name` указывается название replica set

В параметре `pmm_client_monitoring_ip` указывается IP адрес сервера мониторинга.

В параметре `pmm_client_monitoring_password` указывается пароль для подключения к серверу мониторинга

В параметре `pmm_client_monitoring_percona_pass` указывается пароль для подключения к базе данных

## Example Playbook

      hosts: db
      become: true
      roles:
        - role: pmm_client
          vars:
            pmm_client_monitoring_ip: xxx.xxx.xxx.xxx
            pmm_client_monitoring_password: xxxxxxxx
            pmm_client_mongodb_percona_pass: mongo123

## License

All Rights Reserved

## Author Information

ail-13
