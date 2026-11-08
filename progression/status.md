# Status

**Fase: primeiro boot sustentado (2026-11-08).** O jogo roda 45 s sem FATAL e encerra limpo pelo timeout.

Feito:

- Repo publicado: https://github.com/pedrohenrique505/Albedo (`main` tracking `origin/main`). Commits: setup, órfãos MCP, lote headless.
- ISO extraída para `game/`; Title ID `445007F7`; SDK v0.10.0 local (KI-01).
- **Lote headless de órfãos:** `scripts/find_orphans.py` (PyGhidra, GUI fechada) achou 172 candidatos; 97 entradas `orphan_*` no manifest após filtrar interiores de thunk, mesclar clusters de switch (`821B…/821C…/821D…/821F4…` fora; `824B4D80`, `8220EE04`, `824DE360`, `82469D74`, `82469070` mesclados com size até a próxima registrada) e declarar tails de validação.
- Codegen: 21.868 funções registradas, **1 único `REX_FATAL("Unresolved`** restante — bloco SEH (`mr r8,r8`) em `0x8246908C → 0x82468FE8`, que o runtime não despacha (ver KI-03).
- **Boot:** `timeout 45 scripts/run.sh` — 0 FATAL, Vulkan apresentando, warnings repetidos de texture fetch (~cadência de frame) e encerramento gracioso (`Window closing / Execution complete`). Antes do lote, o boot morria em ~5 s (`0x824A7818`); depois passou também por `0x8224CD08` (declarado, size 24).

Não verificado visualmente: o que está na tela (menu? logo?) — conferir rodando sem timeout. Ver [next-steps.md](next-steps.md).
