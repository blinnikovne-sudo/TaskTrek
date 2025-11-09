# Требования для сборки APK в sandbox среде

## Проблема

При попытке собрать APK в текущей среде возникает ошибка:
```
dl.google.com: Temporary failure in name resolution
repo.maven.apache.org: Temporary failure in name resolution
```

Это означает, что Gradle не может получить доступ к Maven репозиториям для загрузки зависимостей.

## Что нужно для успешной сборки в песочнице

### 1. Полный доступ к сети
- Разрешение DNS имен: `dl.google.com`, `repo.maven.apache.org`, `maven.google.com`
- HTTPS доступ к репозиториям Maven/Gradle
- Возможность загрузки ~200-300 MB зависимостей

### 2. Предустановленные зависимости (альтернатива)
Если сеть ограничена, нужны:
- Полный Android SDK (platforms/android-34, build-tools/34.0.0)
- Gradle зависимости в локальном кэше
- Все Maven артефакты предзагружены

### 3. Время выполнения
- Первая сборка: 5-10 минут (загрузка зависимостей)
- Последующие сборки: 1-3 минуты

## Текущее состояние моей среды

✅ **Что работает:**
- Node.js и npm
- Apache Cordova
- Java JDK 21
- Gradle 8.14.3
- Базовый HTTP/HTTPS доступ (curl работает)

❌ **Что не работает:**
- DNS разрешение в Gradle (dl.google.com недоступен)
- Загрузка Maven зависимостей
- Android SDK компоненты (нужна сеть для установки)

## Решения

### Вариант 1: Облачная сборка (РЕКОМЕНДУЮ для вас)

Поскольку у вас смартфон, используйте онлайн сервисы:

#### A. GitHub Actions (бесплатно)
Создайте файл `.github/workflows/build-apk.yml`:
```yaml
name: Build APK

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '20'

      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Install Cordova
        run: npm install -g cordova

      - name: Build APK
        run: |
          cd cordova-app
          cordova build android

      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: TaskTrek-APK
          path: cordova-app/platforms/android/app/build/outputs/apk/debug/app-debug.apk
```

После push в GitHub:
1. Перейдите в раздел "Actions"
2. Запустите workflow
3. Скачайте готовый APK из артефактов

#### B. Appetize.io
- Загрузите проект
- Тестируйте прямо в браузере
- Платно, но есть trial

#### C. AppGyver / Monaca Cloud
- Облачная IDE для мобильных приложений
- Бесплатный план доступен

### Вариант 2: Локальный компьютер с полным доступом

Если есть доступ к ПК с интернетом:
```bash
cd cordova-app
cordova build android
```

### Вариант 3: Termux на Android (!)

Вы можете собрать APK прямо на вашем смартфоне через Termux:

```bash
# В Termux
pkg update && pkg upgrade
pkg install nodejs openjdk-17 wget
npm install -g cordova

# Клонируйте репозиторий
git clone <ваш-репозиторий>
cd TaskTrek/cordova-app

# Установите Android SDK (сложно, но возможно)
# Или используйте cordova build --device
```

### Вариант 4: Replit / CodeSandbox

Некоторые облачные IDE поддерживают сборку Android:
- Replit (с правильным конфигом)
- Gitpod (с Android SDK)

## Альтернатива: PWA вместо APK

Если APK не критичен, можно использовать PWA (Progressive Web App):

1. **Добавьте manifest.json:**
```json
{
  "name": "TaskTrek",
  "short_name": "TaskTrek",
  "start_url": "/",
  "display": "standalone",
  "theme_color": "#ff8c4d",
  "background_color": "#ffffff",
  "icons": [
    {
      "src": "icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

2. **Добавьте Service Worker**
3. **Разместите на GitHub Pages**
4. **Пользователи смогут "установить" через браузер**

## Альтернатива 2: Использовать готовый веб-контейнер

Сервис **PWABuilder.com**:
1. Откройте https://www.pwabuilder.com/
2. Введите URL вашего веб-приложения
3. Сгенерируйте Android App Bundle
4. Скачайте готовый APK/AAB

Это работает даже со смартфона!

## Что я могу сделать прямо сейчас

Я могу:
1. ✅ Создать структуру проекта Cordova (уже сделано)
2. ✅ Настроить конфигурацию
3. ✅ Создать скрипты сборки
4. ✅ Создать GitHub Actions workflow
5. ✅ Подготовить PWA манифест
6. ✅ Создать Docker образ для сборки

Я **НЕ могу**:
- ❌ Собрать APK из-за сетевых ограничений
- ❌ Загрузить Android SDK компоненты
- ❌ Получить доступ к Maven репозиториям

## Рекомендация для вас

**Лучший вариант для кодинга через смартфон:**

1. **GitHub Actions** - создайте workflow, и APK будет собираться автоматически
2. **PWABuilder** - самый быстрый способ получить APK прямо сейчас
3. **Termux** - если хотите всё делать на телефоне

Хотите, я создам GitHub Actions workflow для автоматической сборки APK?
