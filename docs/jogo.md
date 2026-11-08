# O jogo — inventário da ISO (USA, Europe)

- Arquivo: `Ben 10 - Ultimate Alien - Cosmic Destruction (USA, Europe).iso` (7.838.695.424 bytes)
- SHA-256: `54e7b3f68a7058162e9cf8780193ee84ba44a9c89dc0cbb7a76f6f56cb4b5fff`
- Conteúdo: 1.352 arquivos, 5.435.433.670 bytes (`extract-xiso -l`)

## Executável

- `/default.xex` — 7.708.672 bytes, SHA-256 `4e8c3b121081ce26fd3ec61f28e935951a755d7015ae42e23a2c7899b730dd89`, PE interno `ben10_ua_xbox.exe`. Alvo do codegen e do Ghidra (PowerPC BE, XEX2).
- Title ID `445007F7`, Media ID `78E3E986`, versão `0.0.0.2`, filetime 2010-09-10 (via `rexglue codegen`). 21.784 funções recompiladas.

## Layout

| Prefixo | Conteúdo |
|---|---|
| `/fmv/` (+ `/fmv/l_*`) | Cutscenes `.wmv` por nível/idioma (att, bonus, cartnet, papaya, havok…) |
| `/global/` | Assets globais `.xbx`, `Ben10.TTF`, scripts em `/global/scripts/` |
| `/l_*/` | Níveis: `l_chin`, `l_mili`, `l_pari`, `l_romd`, `l_romn`, `l_rush`, `l_tokd`, `l_tokn`, `l_toyn`… cada um com `.xbx`, `scripts/`, `snd_xbx/`, `vo/` |
| `/global/scripts/*.ds`, `*.ddf`, `*.at` | Scripts/dados da engine (`.ds`/`.ddf` texto, `archetyp.at`) |
| `snd_xbx/*.fev`, `*.fsb` | Áudio FMOD (por nível: `b10_*.fev` + bancos `.fsb`) |
| `/nxeart`, `/system.cnf`, `/$SystemUpdate/` | Arte NXE, config, update de sistema (ignorar) |

Observações para o recomp:

- Áudio é FMOD — esperar superficie de stubs XAudio/FMOD no runtime até mapear as chamadas do XEX.
- Scripts `.ds`/`.ddf` são dados interpretados pela engine, não código PPC: não entram no codegen.
- Title ID / entry point / imports: extrair do header XEX após a extração (próximo passo em `progression/next-steps.md`).
