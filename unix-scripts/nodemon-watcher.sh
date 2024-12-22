#!/bin/bash

echo "STARTER NODEMON WATCHER!"

chmod 777 unix-scripts/omp-server-starter.sh || echo "omp-server-starter.sh не найден или недоступен"
chmod +x unix-scripts/omp-server-starter.sh

# tail -f /dev/null

if ! command -v nodemon &> /dev/null; then
    echo "nodemon не установлен. Установите nodemon перед запуском этого скрипта."
    exit 1
fi

nodemon

# ./unix-scripts/omp-server-starter.sh