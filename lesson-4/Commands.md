# Полезные команды Docker

## Информация о контейнерах
Показывает информацию о ресурсах потребляемых контейнерами

    docker stats

Показывает сколько дискового пространства занимают образы, контейнеры и volume

    docker system df

Показывает информаицю о контейнере

    docker inspect mongodb

Показывает конкретный параметр контейнера

    docker inspect -f "{{.State.Status}}" mongodb

## Работа с логами
Показывает логи контейнера. Логи показываются только в том случае если они не перенаправлены для этого контейнера

    docker logs mongodb

Показывает логи в реальном времени

    docker logs mongodb -f

Найти нужный текст в логах и выдать максимум 10 найденных вариантов

    docker logs mongodb | grep "error" -m 10

Найти нужный текст в логах и дополнительно выдать 10 записей после найденного текста

    docker logs mongodb | grep "error" -A 10

Найти нужный текст в логах и дополнительно выдать 10 записей перед найденным текстом

    docker logs mongodb | grep "error" -B 10


## Взаимодействие с образами
Создать образ. В текущем каталоге ищется файл `Dockerfile` и создается образ с названием `mongodb:7.0`

    docker build -t mongodb:7.0 .

Список образов

    docker images

Удалить образ

    docker rmi

Удалить все неиспользуемые образы

    docker image prune

Проанализировать образ. Должен быть установлен dive

    dive mongodb:7.0

## Взаимодействие с контейниером
Создать и запустить контейнер. Параметр `-p` - проброс портов, `-v` - монтирование к контейнеру хостовых каталогов, `-d` - запустить контейнер в фоновом режиме

    docker run --name mongodb -p 27001:27001 -v /db:/db -d mongodb:7.0

Список запущенных контейнеров

    docker ps

Список всех контейнеров

    docker ps -a

Остановить контейнер

    docekr stop mongodb

Запустить созданный контейнер

    docekr start mongodb


Выполнение команды из хоста в контейнере

    sudo docker exec mongodb <Команда>

Выполнение команды из хоста в контейнере в интерактивном режиме, так можно подключиться к контейнеру

    docker exec -it mongodb bash

Удалить все контейнеры

    docker rm $(docker ps -aq)

## Работа с сетью
Список всех сетей

    docker network ls

Информация о сети "bridge"

    docker inspect bridge

Создать сеть

    docker network create my-network

Подключить контейнер к сети

    docker network connect my-network mongodb

Создать контейнер на хостовой сети, может буть полезно если контейнеру не нужна своя сеть

    docker run --name mongodb --network host -d mongodb:7.0

Создать контейнер без доступа к сеть

    docker run --name mongodb --network none -d mongodb:7.0