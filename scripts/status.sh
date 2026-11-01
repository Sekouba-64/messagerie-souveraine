#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "=== État des services Docker ==="
docker compose ps

echo
echo "=== Test PostgreSQL ==="
if docker compose exec -T postgres pg_isready -U synapse -d synapse; then
    echo "PostgreSQL est disponible."
else
    echo "PostgreSQL n'est pas disponible."
fi

echo
echo "=== Test de l'API Matrix ==="
HTTP_CODE="$(curl -sS -o /dev/null -w "%{http_code}" \
    --max-time 10 \
    http://127.0.0.1:8008/_matrix/client/versions || true)"

if [ "$HTTP_CODE" = "200" ]; then
    echo "Synapse répond correctement : HTTP $HTTP_CODE"
else
    echo "Synapse ne répond pas correctement : HTTP ${HTTP_CODE:-inconnu}"
fi
