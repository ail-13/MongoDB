#!/bin/bash
set -e

# Устанавливаем Docker
# Скачиваем и конвертируем в GPG открытый ключ Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
# Добавляем ссылку на репозиторий
echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu focal stable" | sudo tee /etc/apt/sources.list.d/docker.list
# Обновляем репозитории
sudo apt-get update
# Устанавливаем Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Добавляем текущего пользователя в группу docker чтобы можно было работать с Docker`ом без sudo
# Чтобы изменения вступили в силу необходимо перелогиниться
sudo usermod -aG docker $USER

# Устанавливаем dive для анализа созданных образов
curl -OL https://github.com/wagoodman/dive/releases/download/v0.11.0/dive_0.11.0_linux_amd64.deb
sudo apt install ./dive_0.11.0_linux_amd64.deb