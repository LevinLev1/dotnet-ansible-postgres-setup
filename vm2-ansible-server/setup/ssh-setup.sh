#!/bin/bash

# Конфигурация SSH для Ansible
# Этот скрипт настраивает подключение к App Server (VM1)

# Параметры подключения
TARGET_USER="leov"              # Пользователь на VM1
TARGET_IP="10.0.2.7"            # IP-адрес VM1
SSH_KEY_NAME="ansible_vm1_key"  # Имя ключа SSH
KEY_PATH="$HOME/.ssh/$SSH_KEY_NAME"

echo "=== Настройка SSH-подключения к App Server ==="

# 1. Проверка существования ключа
if [ ! -f "$KEY_PATH" ]; then
    echo "Генерация нового SSH-ключа..."
    ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N "" -C "ansible@vm2"
    chmod 600 "$KEY_PATH"
    chmod 644 "$KEY_PATH.pub"
else
    echo "SSH-ключ уже существует: $KEY_PATH"
fi

# 2. Копирование публичного ключа на VM1
echo "Копирование публичного ключа на $TARGET_USER@$TARGET_IP..."
ssh-copy-id -i "$KEY_PATH.pub" "$TARGET_USER@$TARGET_IP"

# 3. Проверка подключения
echo "Проверка SSH-подключения..."
ssh -i "$KEY_PATH" -o BatchMode=yes -o ConnectTimeout=5 "$TARGET_USER@$TARGET_IP" exit

if [ $? -eq 0 ]; then
    echo "Успех: SSH-подключение работает без пароля!"
else
    echo "Ошибка: Не удалось установить SSH-подключение"
    exit 1
fi

# 4. Создание конфигурации для Ansible
echo "Создание SSH-конфигурации для Ansible..."
cat > ~/.ssh/config <<EOF
Host app-server
    HostName $TARGET_IP
    User $TARGET_USER
    IdentityFile $KEY_PATH
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF

chmod 600 ~/.ssh/config

echo "=== Настройка завершена успешно! ==="
echo "Теперь вы можете подключаться командой: ssh app-server"
