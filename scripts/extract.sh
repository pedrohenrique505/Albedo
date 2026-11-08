#!/usr/bin/env bash
# Extracts the game ISO into ./game (requires extract-xiso on PATH).
# Usage: scripts/extract.sh [path-to-iso]
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ISO="${1:-$ROOT/Ben 10 - Ultimate Alien - Cosmic Destruction (USA, Europe).iso}"
OUT="$ROOT/game"
mkdir -p "$OUT"
extract-xiso -d "$OUT" -x "$ISO"
ls -lh "$OUT/default.xex"
ls "$OUT" | head -n 30
