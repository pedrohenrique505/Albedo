# Next steps

1. **Autenticar e publicar:** `gh auth login -h github.com`, revisar stage, commit inicial, `git push -u origin main`.
2. ~~SDK~~ ✓ (copiado do `beatles-recomp`; trocar por `scripts/setup_rexglue.sh` quando o `gh` voltar).
3. ~~Extrair~~ ✓ (`game/` completo; Title ID `445007F7`).
4. **Ghidra em lote (desbloqueia o KI-03):** instalar XEXLoaderWV (`tools/xexloader/ghidra_12.0.4_PUBLIC_20260325_XEXLoaderWV.zip`) + Jython, importar `default.xex` (`PowerPC:BE:64:A2ALT-32addr`, base `0x82000000`), e dimensionar a região `0x82154A08…` e demais alvos órfãos. Alternativa: adaptar `find_orphans.py`/`resolve_orphans.py` do `beatles-recomp`.
5. **Loop FATAL → manifest:** a cada `[FATAL] ... guest address 0x...`, dimensionar no Ghidra, declarar em `[entrypoint.functions]` (com `size` quando for thunk), `scripts/codegen.sh` + `scripts/build.sh` + boot, até passar da inicialização. Manter `grep REX_FATAL("Unresolved` = 0.
6. **Depois do boot:** classificar shaders ausentes (KI-04), stubs de kernel/XAM no `build/run.log` e primeiro frame renderizado.
