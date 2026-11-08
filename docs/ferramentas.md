# Ferramentas

| Ferramenta | Versão / local | Uso |
|---|---|---|
| ReXGlue SDK | v0.10.0 prebuilt → `tools/rexglue/linux-amd64/` | `rexglue codegen` (XEX → C++) + runtime (kernel/XAM, Xenos Vulkan, SDL) |
| Ghidra | 12.1.2 em `/opt/ghidra` | Análise PPC do `default.xex`, sizing de funções órfãs |
| XEXLoaderWV | zip em `tools/xexloader/` | Loader XEX2 no Ghidra (requer Jython habilitado) |
| REA (rea-agents) | 6.8.0 via `npx -y rea-agents@6.8.0` | Orquestra providers; provider Ghidra saudável |
| GhidraMCP | plugin na GUI, `127.0.0.1:8080` | Tools `mcp__ghidra__*` nesta sessão (só com GUI + programa aberto) |
| extract-xiso | `/usr/bin/extract-xiso` (AUR git) | ISO → `game/` |
| Build | clang 23, cmake, ninja, mold, ccache | `scripts/build.sh` (`-j2`) |

## REA — estado verificado (2026-11-08)

`npx -y rea-agents@6.8.0 doctor --json`:

- `ghidra`: healthy — `/opt/ghidra`, 12.1.2, headless ok, Java 27 (JDK 21+ aceito)
- `node` 26.13.0, host omarchy: healthy
- Ausentes e **irrelevantes** para XEX/PPC: Hopper, IDA, JADX, Kuna
- Registrations `claude_code`/`codex`/`opencode`/`antigravity`/`gemini_cli`: aligned; `hermes`/`pi`/`vscode`: drift (não bloqueia este projeto)
- Skill REA v49 aligned. As tools MCP do REA não estão carregadas nesta sessão do Muse — usar o CLI `rea` (`doctor`, `inspect`, `function`, `decompile` com `--file`) ou abrir o Ghidra GUI para o GhidraMCP.

Não rodar `rea setup` sem plano `--dry-run` revisado: ele escreve config de clientes e pode substituir a skill.

## Ghidra headless vs GUI

- Headless (sem MCP): `scripts/ghidra_headless.sh` importa o XEX com `PowerPC:BE:64:A2ALT-32addr`.
- GUI + MCP: abrir `albedo.gpr`, programa `default.xex` no CodeBrowser, plugin GhidraMCP ativo → `get_program_info`, `list_functions`, `decompile_function_by_address` etc. funcionam.
