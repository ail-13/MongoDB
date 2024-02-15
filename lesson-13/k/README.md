## Установка Ingress
Для доступа к приложению извне кластера необходимо установить Ingress. Для этого необходимо выполнить следующие шаги:

1. Установка Ingress

        helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
        helm repo update
        helm install my-nginx-ingress ingress-nginx/ingress-nginx --set controller.publishService.enabled=true

1. Проверяем что Ingress установлен

        kubectl get services

1. Для доступа к приложению необходимо прописать ip адрес ingress контроллера в файле `C:\Windows\System32\drivers\etc\hosts`

        x.x.x.x demo.test

## Подготовка к запуску
После запуска PostgreSQL необходимо создать таблицу для хранения ссылок. Для этого:

1. Подключаемся к контейнеру с PostgreSQL
    
        kubectl get node
        kubectl exec -it <node_name> -- /bin/bash
1. Подключаемся к PostgreSQL

        psql -U myuser -d mydb

1. Создаем таблицу

        CREATE TABLE "Link" ("id" SERIAL NOT NULL, "url" TEXT NOT NULL, "hash" TEXT NOT NULL, CONSTRAINT "Link_pkey" PRIMARY KEY("id"));

1. Проверяем что таблица создана

        SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'Link';