# Log

## 2026-11-08 — setup inicial

- `git init -b main` + remote `git@github.com:pedrohenrique505/Albedo.git`.
- ISO inventariada com `extract-xiso -l`: 1.352 arquivos / 5.435.433.670 bytes; `default.xex` 7.708.672 bytes; SHA-256 da ISO registrado em `docs/jogo.md`.
- REA doctor: Ghidra 12.1.2 healthy em `/opt/ghidra` (Java 27); Hopper/IDA/JADX/Kuna ausentes (irrelevantes p/ XEX).
- GhidraMCP testado: `BACKEND_UNAVAILABLE` (GUI fechada) — esperado.
- Scaffold criado: `.gitignore`, `README.md`, `CLAUDE.md`, `AGENTS.md`, `project/{albedo_manifest.toml,CMakeLists.txt,src/{main.cpp,albedo_app.h}}`, `scripts/{extract,setup_rexglue,codegen,build,run,ghidra_headless}.sh`, `docs/{ferramentas,jogo}.md`, `progression/{status,next-steps,known-issues,log}.md`.
- Extração completa para `game/`; SDK v0.10.0 copiado do `beatles-recomp` (KI-01).
- Codegen: Title ID `445007F7`; 4 órfãos de validação declarados → passou (21.784 funções, 0 unresolved). Build ok (33 MB).
- Boot 1: FATAL `0x82154A08`. Declarado sem size → Boot 2: FATAL `0x82154A20` (+0x18, thunks de 24 B).
- Diagnóstico do core (PID 20561): SIGABRT via `InvalidFunctionTrap`→`abort()` na thread guest; sem OOM/shm cheio. Registrado como KI-03; não repetir o mesmo binário.

## 2026-11-08 — lote de órfãos e primeiro boot sustentado

- Commit `57af89d` (setup) e `82a0269` (órfãos `82154A08/A20` sized via MCP: boot ~5 s, FATAL seguinte `824A7818`).
- GUI fechada a pedido; lote headless com `scripts/find_orphans.py` (PyGhidra sobre cópia do projeto em `build/ghidra-work/`): 172 candidatos.
- Filtragem: size só p/ thunks ≤32; clusters de switch (`821B/821C/821D/821F4`) removidos (204→24 unresolved); merges com size até a próxima registrada (`824B4D80` 276, `8220EE04` 264, `824DE360` 384, `82469D74` 188, `82469070` 92) → 1 unresolved (SEH `8246908C→82468FE8`).
- Runtime: FATAL `8224CD08` sized 24 via `scripts/size_of.py` e declarado. **Boot de 45 s: 0 FATAL, shutdown limpo pelo timeout.**
