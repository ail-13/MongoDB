# Ansible Role: ppm_client

Устанавливает и настраивает Percona Monitoring and Management Client

## Requirements

Тестировалась только на Ubuntu

## Role Variables

В параметре `monitoring_ip` указывается IP адрес сервера мониторинга.

В параметре `monitoring_password` указывается пароль для подключения к серверу мониторинга

## Example Playbook

      hosts: db
      become: true
      roles:
        - role: pmm_client
          vars:
            monitoring_ip: xxx.xxx.xxx.xxx
            monitoring_password: xxxxxxxx

## License

All Rights Reserved

## Author Information

ail-13
