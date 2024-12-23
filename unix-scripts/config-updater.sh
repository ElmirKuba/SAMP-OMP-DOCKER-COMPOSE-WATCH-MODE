#!/bin/bash

update_ini_file() {
    local file="$1"
    local key="$2"
    local value="$3"

    if [[ ! -f "$file" ]]; then
        echo "Файл $file не найден!"
        return 1
    fi

    awk -v key="$key" -v value="$value" '
    BEGIN { found=0 }
    {
        if ($1 == key && $2 == "=") {
            $3 = value
            found=1
        }
        print
    }
    END {
        if (!found) {
            print key " = " value
        }
    }
    ' "$file" > "$file.tmp"

    cat "$file.tmp" > "$file"
    rm "$file.tmp"

    echo "Ключ $key успешно обновлён в $file."
}

update_ini_file "omp-server/mysql.ini" "hostname" "$MYSQL_HOST_AND_NAME_DATABASE"
update_ini_file "omp-server/mysql.ini" "username" "$MYSQL_USER"
update_ini_file "omp-server/mysql.ini" "database" "$MYSQL_HOST_AND_NAME_DATABASE"
update_ini_file "omp-server/mysql.ini" "password" "$MYSQL_PASSWORD"

change_json_key() {
    local key_path="$1"
    local value="$2"
    local json_file="$3"
    local value_type="$4"

    if [ ! -f "$json_file" ]; then
        echo '{}' > "$json_file"
    fi

    if [ "$value_type" == "string" ]; then
        value="\"$value\"" # Заключаем значение в кавычки
    elif [ "$value_type" != "number" ]; then
        echo "Ошибка: Неверный тип значения '$value_type'. Используйте 'string' или 'number'."
        return 1
    fi

    if ! jq --argjson key_path "$(echo "$key_path" | jq -R 'split(".")')" \
           --argjson value "$value" \
           'setpath($key_path; $value)' "$json_file" > "$json_file.updated"; then
        echo "Ошибка обновления ключа $key_path в $json_file."
        return 1
    fi

    cat "$json_file.updated" > "$json_file"
    rm "$json_file.updated"
    echo "Ключ $key_path успешно обновлён в $json_file как $value_type."
}

change_json_key "artwork.port" "$OMP_SERVER_PORT" "omp-server/config.json" "number"
change_json_key "network.port" "$OMP_SERVER_PORT" "omp-server/config.json" "number"
change_json_key "rcon.password" "$OMP_SERVER_RCON" "omp-server/config.json" "string"
change_json_key "website" "$OMP_SERVER_WEBSITE" "omp-server/config.json" "string"
change_json_key "max_players" "$OMP_SERVER_PLAYERS" "omp-server/config.json" "number"

change_json_array() {
    local key_path="$1"
    local array="$2"
    local json_file="$3"

    if [ ! -f "$json_file" ]; then
        echo '{}' > "$json_file"
    fi

    if ! echo "$array" | jq -e '.' > /dev/null 2>&1; then
        echo "Ошибка: $array не является допустимым JSON-массивом."
        return 1
    fi

    if ! jq --argjson key_path "$(echo "$key_path" | jq -R 'split(".")')" \
           --argjson array "$array" \
           'setpath($key_path; $array)' "$json_file" > "$json_file.updated"; then
        echo "Ошибка обновления массива $key_path в $json_file."
        return 1
    fi

    cat "$json_file.updated" > "$json_file"
    rm "$json_file.updated"
    echo "Массив $key_path успешно обновлён в $json_file."
}

change_json_array "pawn.legacy_plugins" "$OMP_SERVER_PLUGINS" "omp-server/config.json"
change_json_array "pawn.main_scripts" "$OMP_SERVER_GAMEMODES" "omp-server/config.json"

return 0