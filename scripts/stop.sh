#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Arrêt de l'infrastructure..."
docker compose down

echo
echo "Les conteneurs ont été arrêtés."
echo "Les volumes et les données PostgreSQL sont conservés."
