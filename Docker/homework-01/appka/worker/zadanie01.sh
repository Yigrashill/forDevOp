#!/usr/bin/env bash
set -euo pipefail

IMAGE="localhost/isa_worker:0.1.0-dev"
NAME="isa_worker"
PORT_HOST=8000
PORT_CONT=8000

cleanup() {
  # stop + remove kontenera jeśli istnieje (bez wywalania skryptu)
  docker rm -f "$NAME" >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "1) Build obrazu: $IMAGE"
docker image build --tag "$IMAGE" -f Docker/Dockerfile .

echo "2) Run kontenera: $NAME (REDIS_DISABLED=1) + publikacja portu ${PORT_HOST}:${PORT_CONT}"
docker container run -d \
  --name "$NAME" \
  --env REDIS_DISABLED=1 \
  -p "${PORT_HOST}:${PORT_CONT}" \
  "$IMAGE" >/dev/null

echo "3) Sleep 10s"
sleep 10

echo "4) Logi z kontenera (ostatnie 80 linii)"
docker container logs --tail 80 "$NAME"

echo "5) PUT seconds=2137 przez REST API (z hosta)"
# (opcjonalnie) krótki check czy API żyje – nie zmienia wymagania sleepów
curl -fsS "http://localhost:${PORT_HOST}/" >/dev/null

curl -fsS -X PUT "http://localhost:${PORT_HOST}/api/v1/seconds/2137" | cat
echo

echo "6) Sleep 15s"
sleep 15

echo "7) Logi z kontenera (ostatnie 80 linii)"
docker container logs --tail 80 "$NAME"

echo "8) Stop kontenera"
docker container stop "$NAME" >/dev/null
echo "OK"
