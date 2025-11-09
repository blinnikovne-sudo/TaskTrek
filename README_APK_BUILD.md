# Инструкция по сборке APK для TaskTrek

Этот документ содержит пошаговые инструкции для создания APK файла из HTML приложения TaskTrek.

## Готовый проект Cordova

В папке `cordova-app` находится готовый проект Apache Cordova с вашим приложением TaskTrek.

## Предварительные требования

Для сборки APK на вашем локальном компьютере вам понадобится:

1. **Node.js** (версия 14 или выше)
   - Скачать: https://nodejs.org/

2. **Java JDK** (версия 11 или выше)
   - Скачать: https://www.oracle.com/java/technologies/downloads/
   - Или OpenJDK: https://adoptium.net/

3. **Android Studio** (для Android SDK)
   - Скачать: https://developer.android.com/studio
   - Или Android Command Line Tools: https://developer.android.com/studio#command-tools

4. **Apache Cordova**
   ```bash
   npm install -g cordova
   ```

## Настройка переменных окружения

После установки Android Studio или Command Line Tools, настройте переменные окружения:

### Windows
```cmd
setx ANDROID_HOME "C:\Users\ВашеИмя\AppData\Local\Android\Sdk"
setx PATH "%PATH%;%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\cmdline-tools\latest\bin"
```

### macOS/Linux
Добавьте в `~/.bashrc` или `~/.zshrc`:
```bash
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
```

Затем выполните:
```bash
source ~/.bashrc  # или source ~/.zshrc
```

## Сборка APK

### Метод 1: Использование готового проекта Cordova

1. Перейдите в папку проекта:
   ```bash
   cd cordova-app
   ```

2. Соберите APK:
   ```bash
   cordova build android
   ```

3. Готовый APK будет находиться в:
   ```
   cordova-app/platforms/android/app/build/outputs/apk/debug/app-debug.apk
   ```

### Метод 2: Создание нового проекта (если готовый не работает)

1. Создайте новый проект Cordova:
   ```bash
   cordova create myapp com.tasktrek.app TaskTrek
   cd myapp
   ```

2. Скопируйте HTML файлы:
   ```bash
   cp ../index.html www/
   cp ../task_tracker.html www/
   ```

3. Добавьте платформу Android:
   ```bash
   cordova platform add android
   ```

4. Скопируйте конфигурацию из готового проекта:
   ```bash
   cp ../cordova-app/config.xml .
   ```

5. Соберите APK:
   ```bash
   cordova build android
   ```

## Сборка Release версии (для публикации)

Для создания подписанной версии APK для публикации в Google Play:

1. Создайте keystore:
   ```bash
   keytool -genkey -v -keystore tasktrek-release.keystore -alias tasktrek -keyalg RSA -keysize 2048 -validity 10000
   ```

2. Создайте файл `build.json` в корне проекта:
   ```json
   {
     "android": {
       "release": {
         "keystore": "tasktrek-release.keystore",
         "storePassword": "ваш_пароль",
         "alias": "tasktrek",
         "password": "ваш_пароль"
       }
     }
   }
   ```

3. Соберите release версию:
   ```bash
   cordova build android --release
   ```

4. Готовый APK будет в:
   ```
   platforms/android/app/build/outputs/apk/release/app-release.apk
   ```

## Быстрая сборка (без Android Studio)

Если вы не хотите устанавливать Android Studio, можно использовать только Command Line Tools:

1. Скачайте Android Command Line Tools
2. Распакуйте в папку (например, `~/android-sdk`)
3. Установите необходимые компоненты:
   ```bash
   sdkmanager "platform-tools" "platforms;android-35" "build-tools;35.0.0"
   ```
4. Настройте ANDROID_HOME и соберите проект

## Альтернатива: Онлайн сборка

Если локальная сборка не работает, можно использовать онлайн сервисы:

1. **Capacitor** (современная альтернатива Cordova):
   - https://capacitorjs.com/

2. **PWA Builder** (для создания Android пакета из PWA):
   - https://www.pwabuilder.com/

3. **Monaca** (облачная сборка):
   - https://monaca.io/

## Установка APK на устройство

1. Включите "Установка из неизвестных источников" на Android устройстве
2. Перенесите APK файл на устройство
3. Откройте файл и нажмите "Установить"

Или используйте ADB:
```bash
adb install app-debug.apk
```

## Проблемы и решения

### Ошибка: "ANDROID_HOME not set"
Убедитесь, что переменная окружения ANDROID_HOME установлена правильно.

### Ошибка: "Could not find gradle"
Убедитесь, что Gradle установлен или используйте Gradle wrapper, который создается автоматически.

### Ошибка при сборке
Попробуйте очистить проект:
```bash
cordova clean android
cordova build android
```

## Дополнительная информация

- Документация Cordova: https://cordova.apache.org/docs/
- Руководство по Android: https://cordova.apache.org/docs/en/latest/guide/platforms/android/
- Форум Cordova: https://forum.apache.org/cordova/

---

**Версия:** 1.0.0
**Дата:** 2025-11-09
