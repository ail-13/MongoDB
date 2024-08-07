# Установка MongoDB в Kubernetes

## Подготовка
Работа с кластером Kubernetes будет осуществляться из под WSL2, для управления кластером на WSL2 необходимо установить `kubectl`, `helm`, `gcloud CLI`. Для установки необходимо выполнить следующие шаги:

1. Установка `kubectl`

        curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
        echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
        echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
        sudo apt-get update
        sudo apt-get install kubectl

1. Установка `helm`

        curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
        sudo apt-get install apt-transport-https --yes
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
        sudo apt-get update
        sudo apt-get install helm

1. Установка `gcloud CLI`

        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
        sudo apt-get update
        sudo apt-get install google-cloud-cli
        sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin

## Установка Kubernetes
Kubernetes будем разворачивать в GKE с помощью Terraform. Необходимо выполнить следующие шаги:

1. Создать проект в GCP
1. Создать ключ для сервисного аккаунта в формате JSON, скачать его и положить в файл `terraform/credentials.json`
1. Создаем файл конфигурации для Terraform `./terraform/dev/terraform.tfvars`
        project      = "GCP_project_name"
        gcp_project  = "lesson-13"
        worker_count = 3

1. Разворачиваем все необходимые ресурсы

        cd ./terraform/dev
        terraform init
        terraform apply

1. После развертывания кластера Terraform выдаст команду для подключения к кластеру. Ее необходимо выполнить в консоли WSL2

        gcloud container clusters get-credentials GCP_project_name --zone europe-west1-b --project lesson-13

1. Добавляем репозиторий Bitnami

        helm repo add bitnami https://charts.bitnami.com/bitnami

1. Запускаем развертывание MongoDB

        cd ./../../mongodb
        helm install mongo bitnami/mongodb --values values.yml

1. После развертывания MongoDB можно подключиться к кластеру. Для этого будет запущен под с mongosh, который можно использовать для подключения к кластеру

        export MONGODB_ROOT_PASSWORD=$(kubectl get secret --namespace default mongo-mongodb -o jsonpath="{.data.mongodb-root-password}" | base64 -d)
        
        kubectl run --namespace default mongo-mongodb-client --rm --tty -i --restart='Never' --env="MONGODB_ROOT_PASSWORD=$MONGODB_ROOT_PASSWORD" --image docker.io/bitnami/mongodb:7.0.5-debian-11-r6 --command -- bash

        mongosh admin --host "mongo-mongodb-0.mongo-mongodb-headless.default.svc.cluster.local:27017,mongo-mongodb-1.mongo-mongodb-headless.default.svc.cluster.local:27017" --authenticationDatabase admin -u root -p $MONGODB_ROOT_PASSWORD

## Установка Ingress
Для доступа к MongoDB извне кластера необходимо установить Ingress. Для этого необходимо выполнить следующие шаги:

1. Установка Ingress

        helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
        helm repo update
        helm install my-nginx-ingress ingress-nginx/ingress-nginx -n ingress-controller --create-namespace --set controller.publishService.enabled=true

1. Проверяем что Ingress установлен

        kubectl get services -n ingress-controller

1. Для доступа к приложению необходимо прописать ip адрес ingress контроллера в файле `C:\Windows\System32\drivers\etc\hosts`

        x.x.x.x demo.test

## Работа с секретами
Kubernetes хранит секреты в виде base64 строки, поэтому для нормальной работы с секретами можно использовать плагин `helm-secrets` для helm. Для этого необходимо выполнить следующие шаги:

1. Устанавливаем плагин

        helm plugin install https://github.com/jkroepke/helm-secrets

1. Устанавливаем sops

        curl -LO https://github.com/getsops/sops/releases/download/v3.8.1/sops-v3.8.1.linux.amd64
        sudo mv sops-v3.8.1.linux.amd64 /usr/local/bin/sops
        sudo chmod +x /usr/local/bin/sops

1. Генерируем ключ

        gpg --gen-key

1. В файл `.sops.yaml` прописываем ключ

        ---
        creation_rules:
          - pgp: <gpg_key_id>

1. Создаем секрет

        helm secrets encrypt -i secrets.yml

1. Редактируем секрет

        helm secrets edit secrets.yml

1. Запускаем развертывание

        helm secrets upgrade app service -f secrets.yml

## Примечание
Перед подключением к кластеру необходимо выполнить авторизацию в GCP

    gcloud auth login

## Ссылки
https://medium.com/google-cloud/gcp-terraform-to-deploy-private-gke-cluster-bebb225aa7be

https://cloud.google.com/sdk/docs/install#deb

https://helm.sh/docs/intro/install/