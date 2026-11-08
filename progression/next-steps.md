# Next steps

1. **Conferir visualmente:** `scripts/run.sh` sem timeout — o que aparece (logo, menu, FMV)? Input de controle/teclado responde? Registrar em `status.md` com screenshot se possível.
2. **Autenticar e publicar:** `gh auth login -h github.com`, `git push -u origin main`.
3. **Jogar até o próximo FATAL:** cada `[FATAL] ... guest address 0x...` novo → `scripts/size_of.py` (headless, GUI fechada) ou MCP (GUI aberta) → declarar no manifest → codegen/build/boot. Manter o contador `grep -h 'REX_FATAL("Unresolved' project/generated/default/*.cpp | wc -l` em ≤1 (SEH conhecido, KI-03).
4. **Clusters de switch adiados:** regiões `821B…/821C…/821D…/821F4…` ficaram fora do manifest (são corpos de switch/SEH de funções grandes). Se um FATAL cair nelas, tratar como função única com size até a próxima registrada — não declarar os pedaços.
5. **KI-04/KI-05:** shaders `.vsc/.psc` ausentes e texture fetch inválido, depois da conferência visual.
