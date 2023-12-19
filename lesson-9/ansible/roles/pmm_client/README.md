# Ansible Role: ppm_client

Устанавливает и настраивает Percona Monitoring and Management Client

## Requirements

Тестировалась только на Ubuntu

## Role Variables

Значения по умолчанию хранятся в файле `defaults/main.yml`.

    mongodb_port: 27017
    mongodb_rs_name: rs0
    mongodb_percona_name: percona

В параметре `mongodb_port` указывается порт который будет проброшен из контейнера с MongoDB наружу в хостовоую систему. Внутри контейнера MongoDB работает на 27017 порту

В параметре `mongodb_rs_name` указывается название replica set

В параметре `monitoring_ip` указывается IP адрес сервера мониторинга.

В параметре `monitoring_password` указывается пароль для подключения к серверу мониторинга

В параметре `monitoring_percona_pass` указывается пароль для подключения к базе данных

## Example Playbook

      hosts: db
      become: true
      roles:
        - role: pmm_client
          vars:
            monitoring_ip: xxx.xxx.xxx.xxx
            monitoring_password: xxxxxxxx
            mongodb_percona_pass: mongo123

## License

All Rights Reserved

## Author Information

ail-13
