# Ansible Role: docker

Устанавливает на сервер Docker, docker-compose. Добавляет пользователя в группу docker чтобы можно было запускать все команды к docker без `sudo`. Роль выполняется с параметром `become: true`

## Requirements

Тестировалась только на Ubuntu

## Role Variables

У роли есть единственный параметр `docker_user` в нем передается имя пользователя который будет добавлен в групп docker

## Example Playbook

      hosts: db
      roles:
        - role: docker
          vars:
            docker_user: mongo_user

## License

All Rights Reserved

## Author Information

ail-13
