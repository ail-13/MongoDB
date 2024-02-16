## Инициализация Swarm

Инициализация

    docker swarm init

Подключение к Swarm как менеджер

    docker swarm join-token manager

Подключение к Swarm как рабочий узел

    docker swarm join-token worker

Покинуть Swarm

    docker swarm leave


## Узлы Swarm
Приостановить узел

    docker node update --availability pause lesson-4-5-app-stage-3

Возобновить узел

    docker node update --availability active lesson-4-5-app-stage-3

Удалить узел

    docker node update --availability drain lesson-4-5-app-stage-3


## Сервисы Swarm

Создать сервис

    docker service create --name db mongo:4.4

Просмотреть таски сервиса

    docker service ps db

Удалить сервис

    docker service rm db

Запустить 3 реплики сервиса

    docker service scale db=3

Обновить сервис

    docker service update db --image=mongo:5.0

Откатить предыдущее обновление сервиса

    docker service rollback db

Добавить метку к узлам чтобы запустить сервис только на них

    docker node update lesson-4-5-db-stage-1 --label-add db=true
    docker node update lesson-4-5-db-stage-2 --label-add db=true
    docker node update lesson-4-5-db-stage-3 --label-add db=true
    docker service create --name db --replicas 2 --constraint node.labels.db==true mongo:4.4


## Секреты и конфиги Swarm
Зоздать секрет с именем secret_name из файла secret.txt

    docker secret create secret_name secret.txt

Список секретов

    docker secret ls

Удалить секреты

    docker secret rm secret_name

Создать конфиг с именем my_config из файла config.txt

    docker config create my_config config.txt

Удалить конфиг

    docker config rm my_config
