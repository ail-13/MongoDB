# Полезные команды Docker compose

## Работа с контейнерами
Запустить проект

    docker compose up

Запустить проект в фоновоф мержиме

    docker compose up -d

Запустить проект и подтянуть файл с переменными

    docker compose --env--file .env up

Запустить проект под определенным именем

    COMPOSE_PROJECT_NAME=myapp docker compose up -d

Запустить только сервисы с определенным профилем (будут запущены также сервисы у которых не указан профиль)

    docker compose --profile backend up -d
    COMPOSE_PROFILES=backend docker compose up -d

Остановить проект

    docker compose stop

Остановить проект с определенным именем (если для проекта было задано имя, то остановить его можно только по имени)

    COMPOSE_PROJECT_NAME=myapp docker compose stop

Остановить проект и удалить контейнеры (volumes не будут удалены)

    docker compose down

Список запущенных проектов

    docker compose ls

## Конфигурация
Посмотреть итоговую конфигурацию с которой будут собираться контейнеры

    docker compose config

Сделать композицию из нескольких файлов конфигурации

    docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d

Можно вынести описание сервиса из основного файла docker-compose.yml в отдельный файл

    client:
      extends:
        file: ./client/docker-compose.yml
        service: client
      depends_on:
        - mongodb