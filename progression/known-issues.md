# Known issues

- **KI-01 — RESOLVIDO:** `gh` reautenticado como `pedrohenrique505` (SSH) e push inicial feito para https://github.com/pedrohenrique505/Albedo (`main`). SDK segue o v0.10.0 local; `scripts/setup_rexglue.sh` já pode ser usado.
- **KI-02 — GhidraMCP offline:** backend `127.0.0.1:8080` indisponível com a GUI fechada (esperado durante o headless). Reabrir a GUI + CodeBrowser + plugin GhidraMCP reativa.
- **KI-03 — RESOLVIDO p/ o boot atual:** FATAL de função não registrada (`InvalidFunctionTrap`→`abort()`, core PID 20561). Loop fechado com sizing MCP (`82154A08/A20`), lote PyGhidra (172 candidatos → 97 no manifest) e 1 órfão de runtime (`8224CD08`). Boot de 45 s sem FATAL. Resta **1 `REX_FATAL("Unresolved call 0x8246908C → 0x82468FE8`** no código gerado: bloco com marcador SEH `mr r8,r8`; dar `size=136` ao alvo piora (3 unresolved, divide a função) — mantido sem size e documentado. Se um FATAL real cair nesse endereço, revisitar.
- **KI-04 — shaders `game:\global\shaders\*.vsc/.psc` ausentes:** `NtCreateFile FAILED 0xc000000f` no boot (não fatal). Provável shader embutido em `.xbx` ou gerado em runtime; investigar se a imagem estiver errada.
- **KI-05 — texture fetch "invalid type":** warning Vulkan repetido em cadência de frame (`8A020000 0EC80086…`). Não bloqueia; investigar junto da conferência visual.
