#!/usr/bin/env bash
# Downloads the prebuilt ReXGlue SDK v0.10.0 (linux-amd64) into tools/rexglue/.
# Usage: scripts/setup_rexglue.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/tools/rexglue-dl"
gh release download v0.10.0 -R rexglue/rexglue-sdk \
  -p 'rexglue-sdk-0.10.0-linux-amd64.zip' -D "$ROOT/tools/rexglue-dl" --clobber
rm -rf "$ROOT/tools/rexglue"
mkdir -p "$ROOT/tools/rexglue"
unzip -q "$ROOT/tools/rexglue-dl"/rexglue-sdk-0.10.0-linux-amd64.zip -d "$ROOT/tools/rexglue"
"$ROOT/tools/rexglue/linux-amd64/bin/rexglue" --version || true
ls "$ROOT/tools/rexglue/linux-amd64/bin/"
