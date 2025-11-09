#!/bin/bash

# Скрипт для сборки APK из HTML приложения TaskTrek
# Автор: TaskTrek Team
# Версия: 1.0.0

set -e  # Останавливаться при ошибках

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Сборка APK для TaskTrek${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Проверка наличия Node.js
echo -e "${YELLOW}Проверка Node.js...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}Node.js не установлен!${NC}"
    echo "Скачайте и установите Node.js с https://nodejs.org/"
    exit 1
fi
echo -e "${GREEN}✓ Node.js установлен: $(node --version)${NC}"

# Проверка наличия Java
echo -e "${YELLOW}Проверка Java...${NC}"
if ! command -v java &> /dev/null; then
    echo -e "${RED}Java не установлен!${NC}"
    echo "Скачайте и установите Java JDK с https://adoptium.net/"
    exit 1
fi
echo -e "${GREEN}✓ Java установлен: $(java -version 2>&1 | head -n 1)${NC}"

# Проверка наличия Cordova
echo -e "${YELLOW}Проверка Cordova...${NC}"
if ! command -v cordova &> /dev/null; then
    echo -e "${RED}Cordova не установлен!${NC}"
    echo "Установите Cordova командой: npm install -g cordova"
    exit 1
fi
echo -e "${GREEN}✓ Cordova установлен: $(cordova --version)${NC}"

# Проверка ANDROID_HOME
echo -e "${YELLOW}Проверка Android SDK...${NC}"
if [ -z "$ANDROID_HOME" ]; then
    echo -e "${RED}ANDROID_HOME не установлен!${NC}"
    echo "Установите Android SDK и настройте переменную окружения ANDROID_HOME"
    echo "Подробности в README_APK_BUILD.md"
    exit 1
fi
echo -e "${GREEN}✓ ANDROID_HOME: $ANDROID_HOME${NC}"

# Переход в папку проекта
cd "$(dirname "$0")/cordova-app"

echo ""
echo -e "${YELLOW}Очистка предыдущей сборки...${NC}"
if [ -d "platforms/android" ]; then
    cordova clean android
fi

echo ""
echo -e "${YELLOW}Сборка APK...${NC}"
cordova build android

# Проверка успешности сборки
APK_PATH="platforms/android/app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK_PATH" ]; then
    echo ""
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}   ✓ Сборка завершена успешно!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo ""
    echo -e "APK файл находится в:"
    echo -e "${GREEN}$APK_PATH${NC}"
    echo ""
    echo "Размер файла: $(du -h "$APK_PATH" | cut -f1)"
    echo ""
    echo "Для установки на устройство используйте:"
    echo "  adb install $APK_PATH"
    echo ""
    echo "Или перенесите файл на устройство и установите вручную."
else
    echo -e "${RED}Ошибка: APK файл не был создан!${NC}"
    exit 1
fi
