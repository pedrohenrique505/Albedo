#!/usr/bin/env bash
# Recompiles game/default.xex into C++ (project/generated/default/).
# Usage: scripts/codegen.sh [extra rexglue args]
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REXGLUE="$ROOT/tools/rexglue/linux-amd64/bin/rexglue"
[ -x "$REXGLUE" ] || { echo "rexglue não encontrado: rode scripts/setup_rexglue.sh" >&2; exit 1; }
[ -f "$ROOT/game/default.xex" ] || { echo "game/default.xex não encontrado: rode scripts/extract.sh" >&2; exit 1; }
mkdir -p "$ROOT/build"
"$REXGLUE" codegen "$ROOT/project/albedo_manifest.toml" "$@" 2>&1 | tee "$ROOT/build/codegen.log"
echo "--- unresolved check (deve ser 0) ---"
grep -h 'REX_FATAL("Unresolved' "$ROOT"/project/generated/default/*.cpp 2>/dev/null | wc -l || true
