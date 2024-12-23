#!/bin/bash

compile_script() {
    local pwn_name_file="$1"
    local pwn_type_file="$2"

    local PAWN_FILE="omp-server/$pwn_type_file/$pwn_name_file.pwn"
    local OUTPUT_FILE="omp-server/$pwn_type_file/$pwn_name_file.amx"
    local INCLUDE_PATH="omp-server/pawno/include"

    if [ -f "$PAWN_FILE" ]; then
        echo "Компиляция $PAWN_FILE..."
        pawncc "$PAWN_FILE" -o"$OUTPUT_FILE" -i"$INCLUDE_PATH"
        if [ $? -eq 0 ]; then
            echo "Компиляция завершена успешно: $OUTPUT_FILE"
        else
            echo "Ошибка компиляции!"
            exit 1
        fi
    else
        echo "Файл $PAWN_FILE не найден!"
        exit 1
    fi
}

local_gamemodes="$OMP_SERVER_GAMEMODES"

if ! echo "$local_gamemodes" | jq -e '.' > /dev/null 2>&1; then
    echo "Ошибка: OMP_SERVER_GAMEMODES не является валидным JSON-массивом."
    exit 1
fi

num_gamemodes=$(echo "$local_gamemodes" | jq '. | length')

for (( i=0; i<num_gamemodes; i++ )); do
    gamemode=$(echo "$local_gamemodes" | jq -r ".[$i]")

    gamemode_clean=$(echo "$gamemode" | sed -E 's/[[:space:]]+//g' | sed 's/1$//')

    compile_script "$gamemode_clean" "gamemodes"
done

return 0