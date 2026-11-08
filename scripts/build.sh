#!/usr/bin/env bash
# Configure + build. Usage: scripts/build.sh [-j N]
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
JOBS="${1:--j2}"
if [ ! -f "$ROOT/build/albedo/build.ninja" ] && [ ! -f "$ROOT/project/generated/rexglue.cmake" ]; then
  echo "project/generated não existe: rode scripts/codegen.sh primeiro" >&2; exit 1
fi
if [ ! -d "$ROOT/build/albedo" ]; then
  cmake -S "$ROOT/project" -B "$ROOT/build/albedo" -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
    -DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=mold \
    -DCMAKE_CXX_FLAGS="-march=x86-64-v2" \
    -DCMAKE_CXX_FLAGS_RELEASE="-O1 -DNDEBUG" \
    -DREXGLUE_RECOMP_DEBUG_INFO=none \
    -DCMAKE_PREFIX_PATH="$ROOT/tools/rexglue/linux-amd64"
fi
nice -n 10 ninja -C "$ROOT/build/albedo" "$JOBS"
ls -lh "$ROOT/build/albedo/albedo"
