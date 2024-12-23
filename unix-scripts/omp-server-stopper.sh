#!/bin/bash

current_pid=$$

running_processes=$(pgrep -f "./omp-server" | grep -v "$current_pid")

if [ -n "$running_processes" ]; then
    echo "Найдены процессы omp-server: $running_processes"
    echo "$running_processes" | xargs kill -9

    while pgrep -f "./omp-server" | grep -v "$current_pid" > /dev/null; do
        echo "Ожидание завершения процессов omp-server..."
        sleep 1
    done
    echo "Процессы omp-server успешно завершены."
else
    echo "Процессы omp-server не найдены. Пропускаем завершение."
fi

return 0