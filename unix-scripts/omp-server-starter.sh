#!/bin/bash

echo "STARTER OPEN MULTIPLAYER SERVER!"

# OpenMP сервера стоппер ________________________________________
chmod +x unix-scripts/omp-server-stopper.sh
source unix-scripts/omp-server-stopper.sh || {
    echo "Ошибка выполнения omp-server-stopper.sh"
    exit 1
}
# OpenMP сервера стоппер ________________________________________

# Компиляция gamemodes ________________________________________
if [ "$OMP_ENABLE_COMPILATION_GAMEMODES" = "true" ]; then
    echo "Выполняем компиляцию gamemodes"

    chmod +x unix-scripts/gamemodes-compiler.sh
    source unix-scripts/gamemodes-compiler.sh || {
        echo "Ошибка выполнения gamemodes-compiler.sh"
        exit 1
    }
else
    echo "Компиляция gamemodes отключена, по необходимости включите OMP_ENABLE_COMPILATION_GAMEMODES указав true в .env файле."
fi

if ! command -v nodemon &> /dev/null; then
    echo "nodemon не установлен. Установите nodemon перед запуском этого скрипта."
    exit 1
fi
# Компиляция gamemodes ________________________________________

# tail -f /dev/null

# Запуск OpenMP сервера ________________________________________
cd omp-server

./omp-server
# Запуск OpenMP сервера ________________________________________
