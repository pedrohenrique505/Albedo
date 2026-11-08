#!/usr/bin/env bash
# Importa game/default.xex no Ghidra headless (projeto albedo.gpr, git-ignored).
# Requer XEXLoaderWV em tools/xexloader/ (ver docs/ferramentas.md).
# Uso GUI alternativa: abra albedo.gpr no Ghidra com GhidraMCP ativo (porta 8080)
# para liberar as tools mcp__ghidra__* nesta sessão.
# Usage: scripts/ghidra_headless.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export GHIDRA_INSTALL_DIR="${GHIDRA_INSTALL_DIR:-/opt/ghidra}"
[ -f "$ROOT/game/default.xex" ] || { echo "rode scripts/extract.sh antes" >&2; exit 1; }
"$GHIDRA_INSTALL_DIR/support/analyzeHeadless" \
  "$ROOT" albedo -import "$ROOT/game/default.xex" \
  -processor "PowerPC:BE:64:A2ALT-32addr" -overwrite
