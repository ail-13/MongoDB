# Установка MongoDB в Kubernetes
Kubernetes будем разворачивать в GCP с помощью Terraform и kubespray. Необходимо выполнить следующие шаги:

1. Создать проект в GCP
1. Создать ключ для сервисного аккаунта в формате JSON, скачать его и положить в файл `terraform/credentials.json`
1. Создаем файл конфигурации для Terraform `./terraform/dev/terraform.tfvars`
        vm_username     = "mongo_user"
        public_key_path = "~/.ssh/mongo_user"

        gcp_project = "lesson-13"
        gcp_vdc_g = {
                alias            = "g"
                zone             = "europe-west1-b"
                region           = "europe-west1"
        }                                      

1. Разворачиваем все необходимые ресурсы

        cd ./terraform/dev
        terraform init
        terraform apply

1. Скачиваем kubespray

        cd ./../../k8s
        git clone https://github.com/kubernetes-sigs/kubespray.git
        cd kubespray
        git checkout v2.24.0

1. Установливаем зависимости

        pip install -r requirements.txt

1. Копируем инвентори

        rm inventory/sample/inventory.ini
        cp ../environments/dev/inventory.sh inventory/sample/inventory.sh

1. Запускаем установку

        ansible-playbook --private-key=~/.ssh/mongo_user -i inventory/sample/inventory.sh --become --become-user=root cluster.yml

1. После установки проверяем состояние кластера. Все ноды должны быть в статусе `Ready`, а поды в `Running`

        sudo kubectl get node
        sudo kubectl get pods --all-namespaces
