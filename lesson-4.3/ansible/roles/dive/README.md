# Ansible Role: dive

Устанавливает на сервер dive. Dive предназначен для анализа образов Docker. Роль выполняется с параметром `become: true`. При возникновении ошибки в консоль выводится сообщение и выполнение роли прерывается, но другие задачи Ansible продолжат выполняться

## Requirements

Тестировалась только на Ubuntu

## Role Variables

У роли есть единственный параметр `dive_version` в нем передается версия которую нужно установить.

Значения по умолчанию хранятся в файле `defaults/main.yml`.

    dive_version: latest

## Example Playbook

      hosts: db
      roles:
        - role: dive

## License

All Rights Reserved

## Author Information

ail-13
