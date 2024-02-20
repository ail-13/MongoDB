# Ansible Role: preconfig

Устанавливает на сервер htop, mc. Делает предварительную настройку сервера.

## Requirements

Тестировалась только на Ubuntu

## Role Variables

Значения по умолчанию хранятся в файле `defaults/main.yml`.

    preconfig_hosts: []

## Example Playbook

      hosts: db
      roles:
        - role: monitoring
          vars:
            preconfig_hosts:
              - xxx.xxx.xxx.xxx hostname

## License

All Rights Reserved

## Author Information

ail-13
