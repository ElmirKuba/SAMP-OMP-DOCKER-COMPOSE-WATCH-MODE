#!/bin/bash

echo "STARTER NODEMON WATCHER!"

chmod -R 777 omp-server/bans.json || echo "omp-server/bans.json не найден или недоступен"
chmod -R 777 omp-server/config.json || echo "omp-server/config.json не найден или недоступен"
chmod -R 777 omp-server/mysql.ini || echo "omp-server/config.json не найден или недоступен"
chmod -R 777 omp-server/scriptfiles || echo "omp-server/scriptfiles не найден или недоступен"

# Обновлятор конфиг-файлов ________________________________________
if [ "$OMP_ENABLE_CONFIG_UPDATER" = "true" ]; then
    echo "Выполняем обновление конфиг-файлов"

    chmod +x unix-scripts/config-updater.sh
    source unix-scripts/config-updater.sh || {
        echo "Ошибка выполнения config-updater.sh"
        exit 1
    }
else
    echo "Обновлятор конфиг-файлов отключен, по необходимости включите OMP_ENABLE_CONFIG_UPDATER указав true в .env файле."
fi
# Обновлятор конфиг-файлов ________________________________________

# OpenMP сервера стартер ________________________________________
if ! command -v nodemon &> /dev/null; then
    echo "nodemon не установлен. Установите nodemon перед запуском этого скрипта."
    exit 1
fi

chmod 777 unix-scripts/omp-server-starter.sh || echo "omp-server-starter.sh не найден или недоступен"
chmod +x unix-scripts/omp-server-starter.sh

nodemon
# OpenMP сервера стартер ________________________________________