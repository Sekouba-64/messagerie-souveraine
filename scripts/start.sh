#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

echo "Démarrage de l'infrastructure..."
docker compose up -d

echo
echo "État des services :"
docker compose ps
