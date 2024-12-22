#!/bin/bash

NETWORK_NAME="omp-network"

if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    echo "Сеть $NETWORK_NAME уже существует. Удаляем и создаём заново..."
    docker network rm "$NETWORK_NAME"
fi

echo "Создаём сеть $NETWORK_NAME..."
docker network create "$NETWORK_NAME"
