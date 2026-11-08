#!/usr/bin/env bash
# Runs the recompiled game. Usage: scripts/run.sh [extra args]
# Log: build/run.log — smoke test: timeout 60 scripts/run.sh (124=ok, 134=abort/FATAL)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

for f in /dev/shm/xenia_memory_*; do
  [ -O "$f" ] || continue
  if ! fuser -s "$f" 2>/dev/null; then
    rm -f -- "$f" && echo "run.sh: removed stale $f" >&2
  fi
done

export SDL_AUDIO_DEVICE_SAMPLE_FRAMES="${SDL_AUDIO_DEVICE_SAMPLE_FRAMES:-256}"
export REX_VULKAN_ALLOW_PRESENT_MODE_IMMEDIATE="${REX_VULKAN_ALLOW_PRESENT_MODE_IMMEDIATE:-false}"
export REX_VULKAN_ALLOW_PRESENT_MODE_MAILBOX="${REX_VULKAN_ALLOW_PRESENT_MODE_MAILBOX:-false}"
export REX_VULKAN_ALLOW_PRESENT_MODE_FIFO_RELAXED="${REX_VULKAN_ALLOW_PRESENT_MODE_FIFO_RELAXED:-false}"
export REX_PRESENT_PACING="${REX_PRESENT_PACING:-true}"
export REX_RENDER_TARGET_PATH_VULKAN="${REX_RENDER_TARGET_PATH_VULKAN:-fbo}"
export REX_EXECUTE_UNCLIPPED_DRAW_VS_ON_CPU="${REX_EXECUTE_UNCLIPPED_DRAW_VS_ON_CPU:-true}"

SDK_LIBS="$ROOT/tools/rexglue/linux-amd64/lib"
if [ -f "$ROOT/build/sdk-lib/librexruntime.so" ]; then
  SDK_LIBS="$ROOT/build/sdk-lib:$SDK_LIBS"
  echo "run.sh: using patched SDK runtime from build/sdk-lib" >&2
fi
if [ -f "$ROOT/build/sdk-lib/librexgpu-xenos.so" ]; then
  export REXGLUE_GPU_PLUGIN_DIR="$ROOT/build/sdk-lib"
  echo "run.sh: using patched GPU plugin from build/sdk-lib" >&2
fi
export LD_LIBRARY_PATH="$SDK_LIBS:${LD_LIBRARY_PATH:-}"

mkdir -p "$ROOT/build"
: > "$ROOT/build/run.log"
exec "$ROOT/build/albedo/albedo" \
  --game_data_root "$ROOT/game" --gpu_plugin xenos \
  --log_file "$ROOT/build/run.log" "$@"
