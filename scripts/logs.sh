#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$PROJECT_DIR"

LINES="${1:-100}"

if ! [[ "$LINES" =~ ^[0-9]+$ ]]; then
    echo "Usage : $0 [nombre_de_lignes]" >&2
    exit 1
fi

echo "Affichage des $LINES dernières lignes de Synapse..."
echo "Appuyer sur Ctrl+C pour arrêter le suivi."

docker compose logs -f --tail="$LINES" synapse
