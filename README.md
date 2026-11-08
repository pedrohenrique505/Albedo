# Albedo — Ben 10 Ultimate Alien: Cosmic Destruction (Xbox 360) recomp

Static recompilation of *Ben 10 – Ultimate Alien – Cosmic Destruction* (Xbox 360, USA/Europe) into native Linux C++. The PowerPC code in `default.xex` is converted to C++ by the [ReXGlue SDK](https://github.com/rexglue/rexglue-sdk) and compiled against the SDK runtime (kernel/XAM, Xenos GPU on Vulkan, audio and input through SDL).

> **Bring your own disc.** This repository contains **no game code or assets**. You need your own legitimate copy of the game, dumped from a disc you own. Nothing from the game is distributed here, and `game/`, `*.iso` and `*.xex` are git-ignored.

> **Status: first sustained boot.** Title ID `445007F7`; 21,868 functions registered (97 Ghidra-sized orphans in the manifest), build passes, and a 45 s run renders on Vulkan with no FATAL. What is on screen is not yet verified. See [`progression/status.md`](progression/status.md).

## Legal

Not affiliated with or endorsed by Microsoft, D3 Publisher, Papaya Studio or any rights holder. This project is for education and preservation research. Do not use it to distribute copyrighted material.

## Requirements

- Linux x86-64 with a Vulkan-capable GPU.
- `clang`, `cmake`, `ninja`, `mold`, `ccache`, `git`, `python3`, `uv`, `gh` (autenticado).
- `extract-xiso` (AUR: `extract-xiso-git`) to extract the disc image.
- Optional, for analysis only: Ghidra 12.1.2 with the [XEXLoaderWV](https://github.com/zeroKilo/XEXLoaderWV) extension, plus REA (`rea-agents` 6.8.0) with the Ghidra provider.
- About 15 GB of free disk (ISO 7.4 GB + extracted game ~5.4 GB + build).

## Setup

```bash
# 1. Prebuilt SDK (v0.10.0, linux-amd64) into tools/rexglue/
scripts/setup_rexglue.sh

# 2. Extract your disc image (default: ISO na raiz do repo)
scripts/extract.sh "/path/to/Ben 10 - Ultimate Alien - Cosmic Destruction (USA, Europe).iso"

# 3. Recompile the XEX into C++
scripts/codegen.sh

# 4. Configure and build
scripts/build.sh

# 5. Run
scripts/run.sh
```

The run log is written to `build/run.log`.

## Estrutura

- `project/albedo_manifest.toml`: manifest do ReXGlue (funções/órfãos descobertos via Ghidra)
- `project/src/`: host app (`ReXApp`)
- `project/generated/`: código gerado pelo codegen (git-ignored)
- `scripts/`: extract / setup / codegen / build / run / ghidra
- `docs/`: ferramentas e notas do jogo
- `progression/`: status, próximos passos, issues e log
- `patches/`: patches no SDK (quando surgirem)
- `third_party/`: clones de referência (git-ignored)

## Ferramentas

Ghidra 12.1.2 + XEXLoaderWV, REA 6.8.0 (provider Ghidra), ReXGlue SDK v0.10.0. Detalhes em [`docs/ferramentas.md`](docs/ferramentas.md) e no [`CLAUDE.md`](CLAUDE.md).
