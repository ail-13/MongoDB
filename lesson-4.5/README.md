# Тестирование на Vagrant

Для тестирования используется Vagrant и Ansible. Виртуальные машины создаются с помощью Vagrant, а для установки и настройки используется Ansible.

## Подготовка

1. Устанваливаем VirtualBox на Windows
1. Устанавливаем Vagrant на WSL

        wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
        sudo apt update && sudo apt install vagrant

1. Откроем доступ к файловой системе Windows из среды WSL и прописываем путь к VirtualBox в переменные окружения

        echo 'export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"' >> ~/.bashrc
        echo 'export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"' >> ~/.bashrc

1. Устанавливаем плагин для работы с виртуальными дисками

        vagrant plugin install vagrant-disksize

1. Устанавливаем плагин для работы с VirtualBox

        vagrant plugin install virtualbox_WSL2

## Запуск
1. Переходим в папку с ./ansible где лежит Vagrantfile

        cd ./ansible

1. Запускаем виртуальные машины

        vagrant up

1. По ip адреу 192.168.56.10 можно будет подключиться к виртуальной машине с MongoDB

        mongo mongodb://root:mongo123@192.168.56.10:27001
        mongosh 192.168.56.10:27001 -u root -p mongo123
        mongodb://root:mongo123@192.168.56.10:27001

## Тестирование ролей
1. Переходим в папку с ролью

        cd ./ansible/roles/docker

1. Запускаем тестирование

        molecule test

## Примечание
Т.к. Vagrant динамически генерирует инвентори файл для провижининга, то хостовые переменные не будут применены и поэтому все их необходимо указывать в Vagrantfile

## Примечание
Для работы с VirtualBox из WSL возможно придется отключить брандмауэр Windows. Выполним команду

    wf.msc

Нажимаем "Свойства брандмауэра Защитника Windows" и на вкладках "Общий профиль", "Профиль домена" и "Частный профиль" нажимаем "Настройки" для "Защищенные сетевые подключения". И там снимаем галочку "vEthernet (WSL)"

## Примечание
Команды для работы с Vagrant

    vagrant up
    vagrant box list
    vagrant status
    vagrant destroy
    vagrant ssh appserver
    vagrant provision appserver

## Примечание
При работе с Python в WSL необходимо установить инструмент для работы с виртуальными окружениями

    pip install virtualenv
    pip install virtualenvwrapper


    echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3' >> ~/.bashrc && source ~/.bashrc
    echo 'source ~/.local/bin/virtualenvwrapper.sh' >> ~/.bashrc && source ~/.bashrc

Команды:

    mkvirtualenv test-env
    workon
    workon test-env
    deactivate
    rmvirtualenv test-env

## Примечание
При работе с molecule можно использовать команды:

    molecule create             # Создает инстансы
    molecule list               # Показывает список инстансов
    molecule login -h instance  # Подключается к инстансу
    molecule converge           # Запускает плейбук для созданных инстансов
    molecule verify             # Запускает тесты
    molecule destroy            # Удаялет созданные инстансы
    molecule test               # Запускает все шаги тестирования (lint, cleanup, destroy, create, converge, idempotence, side_effect, verify, destroy)