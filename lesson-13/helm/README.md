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