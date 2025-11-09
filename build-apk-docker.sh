#!/bin/bash

# Скрипт для сборки APK с использованием Docker
# Это самый простой способ - не требует установки Android SDK

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Сборка APK через Docker${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Проверка Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker не установлен!${NC}"
    echo "Скачайте и установите Docker с https://www.docker.com/get-started"
    exit 1
fi

echo -e "${GREEN}✓ Docker установлен${NC}"

# Создание папки для выходного файла
mkdir -p output

# Сборка Docker образа
echo ""
echo -e "${YELLOW}Создание Docker образа (это может занять несколько минут)...${NC}"
docker build -f Dockerfile.build -t tasktrek-builder .

# Сборка APK
echo ""
echo -e "${YELLOW}Сборка APK...${NC}"
docker run --rm -v "$(pwd)/output:/output" tasktrek-builder

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   ✓ Готово!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "APK файл находится в: ./output/TaskTrek.apk"
echo ""
