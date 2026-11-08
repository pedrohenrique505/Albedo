This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Static recompilation of *Ben 10 – Ultimate Alien – Cosmic Destruction* (Xbox 360, PowerPC, XEX2) into native Linux C++, using the **prebuilt ReXGlue SDK v0.10.0**. There is no hand-written game code: `project/generated/` is machine output from `rexglue codegen`. Human-authored work is the manifest (`project/albedo_manifest.toml`), the tiny host app (`project/src/`), the helper scripts, and any runtime/kernel/GPU work that ends up needed.

Project status, roadmap and known issues live in `README.md` and `progression/`, not here. Update `progression/` (`status.md`, `next-steps.md`, `known-issues.md`, and a `log.md` entry) when you finish meaningful work.

**All documentation, comments, commit messages and script docstrings are written in English** (docs/ e progression/ em pt-BR são exceção local deste repo), even if the user converses in Portuguese.

## Commands

Pipeline (run from repo root; each step feeds the next):

```bash
scripts/setup_rexglue.sh                 # SDK v0.10.0 -> tools/rexglue/ (precisa `gh` autenticado)
scripts/extract.sh                       # ISO -> game/ (needs extract-xiso); game/default.xex is the input
scripts/codegen.sh                       # XEX -> project/generated/default/*.cpp; log em build/codegen.log
scripts/build.sh                         # cmake + ninja -j2 -> build/albedo/albedo
scripts/run.sh                           # runs the game; log in build/run.log
timeout 60 scripts/run.sh                # smoke test: 124 = rodou até o timeout, 134 = abort/FATAL
```

First-time CMake configure is done by `scripts/build.sh` (clang++ + mold + ccache, `-march=x86-64-v2`, `-O1`). Não usar presets com `clang-20` (não instalado; aqui é clang 23).

Running the binary directly needs `LD_LIBRARY_PATH=tools/rexglue/linux-amd64/lib` and `--game_data_root game --gpu_plugin xenos`; `scripts/run.sh` sets all of that. Without `--gpu_plugin xenos` there is no graphics at all (log: `gpu_plugin not set`). **Boolean flags:** `--name false` sets the flag to *true*; use `--no-name` or `--name=false`.

## Hard constraints

- Always build with `-j2` and `nice`; keep Ghidra GUI closed during full rebuilds. PyGhidra headless is fine alongside the GUI.
- **Never commit or publish game data.** `game/`, `*.iso`, `*.xex` and generated output stay git-ignored. The user supplies their own dump.
- ISO de referência (USA, Europe): SHA-256 `54e7b3f68a7058162e9cf8780193ee84ba44a9c89dc0cbb7a76f6f56cb4b5fff`, 1.352 arquivos, `default.xex` 7.708.672 bytes.

## Architecture

```
game/default.xex ──rexglue codegen──▶ project/generated/default/*.cpp ──clang──▶ build/albedo/albedo
        ▲                                   (funções PPC)                            │ links
 albedo_manifest.toml (hints)                                                  librexruntime.so + librexgpu-xenos.so
                                                                                (kernel/XAM, Vulkan GPU, SDL audio/input)
```

- `tools/rexglue/linux-amd64/` is the downloaded SDK release (binary `rexglue`, `lib/`, `include/`). SDK source for reference goes in `third_party/rexglue-sdk/` (git-ignored); keep SDK changes as patches in `patches/rexglue-sdk/`.
- `project/generated/rexglue.cmake` is generated boilerplate ("DO NOT EDIT"); customize via `project/CMakeLists.txt` (`rexglue_setup_target(albedo GPU_PLUGINS xenos)`) and `project/src/albedo_app.h` (virtual hooks on `rex::ReXApp`).
- Guest ↔ host: recompiled code runs against a big-endian guest memory arena; kernel imports (`xboxkrnl`, XAM, `Vd*`) are implemented by the SDK runtime. Missing/stubbed imports show up in `build/run.log` as `STUB` or `unimplemented` warnings.
- Game data: níveis em `l_*/` (ex.: `l_tokn`, `l_pari`), assets `.xbx`, scripts `.ds`/`.ddf`, áudio FMOD (`.fev`/`.fsb`), FMV `.wmv`. Ver `docs/jogo.md`.

## Manifest gotchas (from the sibling Beatles recomp — same SDK)

1. **Sub-tables belong under `[entrypoint.*]`**. `[functions]` at the root is silently ignored; use `[entrypoint.functions]`. Check `build/codegen.log` for `CONFIG functions` with `--log-level debug`.
2. Function entries: `0xADDR = { name = "...", size = N }`. `size` and `end` are mutually exclusive; omit both to let the analyzer decide. Overlapping config ranges abort manifest loading.
3. `codegen` must pass validation completely: any `b`/`bl` to an address not inside a known function is a hard error (`UnresolvedCall`), even a single one.
4. **Why functions go missing:** the SDK's `VTableScanner` finds vtables only via MSVC RTTI; classes without RTTI leave vtable-only targets (mostly small `this`-adjustor thunks) undiscovered. Symptom at runtime: `[FATAL] Call to invalid or unregistered function at guest address 0x...`.
5. **Patching guest code:** `[[entrypoint.midasm_hook]]` makes codegen call a host function at that instruction; define it in `project/src/`.

## Fixing missing functions (the recurring loop)

- One-off: read the instructions at the address in Ghidra, find where the function ends (first `blr`/`bctr`/unconditional `b` for thunks), add it to `[entrypoint.functions]` with `size`, rerun codegen + ninja.
- After every codegen, check: `grep -h 'REX_FATAL("Unresolved' project/generated/default/*.cpp | wc -l` must be 0.
- **Not every "target not in any function" is a function:** switch case bodies (MSVC jump tables) and SEH resume blocks must not be declared as functions.

## Ghidra / REA

- Ghidra 12.1.2 at `/opt/ghidra`; XEX loader is the `XEXLoaderWV` extension (zip em `tools/xexloader/`, needs Jython extension enabled). Project: `albedo.gpr` in repo root (git-ignored), program `default.xex`, language `PowerPC:BE:64:A2ALT-32addr`.
- The `mcp__ghidra__*` tools only work while the Ghidra GUI has the program open in CodeBrowser with the GhidraMCP plugin enabled (backend `127.0.0.1:8080`); otherwise they return `BACKEND_UNAVAILABLE`. Headless: `scripts/ghidra_headless.sh`.
- REA: `npx -y rea-agents@6.8.0 doctor --json` — provider Ghidra healthy (`/opt/ghidra` 12.1.2, Java 27). Hopper/IDA/JADX/Kuna ausentes são irrelevantes para XEX/PPC. REA MCP tools não estão nesta sessão do Muse; usar o CLI `rea` ou o GhidraMCP com a GUI aberta.

## Debugging a run

`build/run.log` is the SDK log (`--log_file`), truncated by `scripts/run.sh` per run. Crashes produce a core dump (`coredumpctl list`). A `SIGBUS` anywhere means a full `/dev/shm`: check `df -h /dev/shm` for leaked `xenia_memory_*` objects.
