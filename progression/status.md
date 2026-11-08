# Status

**Fase: setup inicial concluído — primeiro FATAL de função não registrada (2026-11-08).**

Pipeline inteiro provado: extrair → codegen → build → boot. Title ID `445007F7` (Media `78E3E986`, build 2010-09-10).

Feito:

- Repo git inicializado (`main`, remote `git@github.com:pedrohenrique505/Albedo.git` — push pendente de `gh auth login`).
- ISO (USA, Europe) identificada e extraída para `game/` (5.1 GB, git-ignored): SHA-256 `54e7b3f6…b5fff`, 1.352 arquivos, `default.xex` 7.708.672 bytes (SHA-256 `4e8c3b12…dd89`, interno `ben10_ua_xbox.exe`, Papaya Studio).
- Scaffold no padrão ReXGlue (referência: `beatles-recomp`): `project/` (manifest + host app mínimo), `scripts/` (extract/setup/codegen/build/run/ghidra), `docs/`, `progression/`.
- Ambiente verificado: Ghidra 12.1.2 + REA 6.8.0 (provider Ghidra healthy; REA não abre XEX2 — quem carrega é o XEXLoaderWV), `extract-xiso`, clang 23/mold/ccache/ninja, Vulkan ok.
- SDK v0.10.0 copiado de `beatles-recomp/tools/rexglue` (mesma versão; `gh` quebrado — KI-01).
- **Codegen passou:** 21.784 funções, 219 arquivos gerados, 0 `Unresolved`. Só 4 órfãos de validação + 1 de runtime declarados no manifest.
- **Build passou:** `build/albedo/albedo` (33 MB).
- **Primeiro boot:** Vulkan + áudio SDL inicializam, guest entra e roda até `[FATAL] Call to invalid or unregistered function at guest address 0x82154A20` — ver diagnóstico em [known-issues.md](known-issues.md) (KI-03).

Próximo: loop de órfãos com sizing via Ghidra. Ver [next-steps.md](next-steps.md).
