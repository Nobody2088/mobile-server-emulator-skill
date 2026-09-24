---
name: mobile-server-emulator
description: >
  End-to-end mobile game server emulator development for Android clients — a
  case-based operating system, not a one-game cheat sheet. Use when you need to
  redirect a game client to your own host, capture and reverse its wire protocol,
  stand up a minimal stub server (login → character → enter world → heartbeat),
  and expose it locally or over frp/ngrok for multiplayer. Ships ten bash
  workflows (doctor, init-workspace, triage, decode, patch-endpoint,
  capture-traffic, proto-extract, frida-hook-run, server-bootstrap, tunnel-setup),
  five stage playbooks with phase gates, protocol note templates (PKT-###),
  failure catalog (F-REDIRECT / F-PROTO / F-SERVER / F-TUNNEL), and Python/Node
  server stubs plus Frida hook templates. Covers Unity IL2CPP (Il2CppDumper,
  string patch, DNS/adb reverse), weak-online JSON/XML in assets, native
  Java/OkHttp/Retrofit, Protobuf and custom TCP/WebSocket framing, SSL capture,
  SQLite persistence, and GitHub emulator discovery. Works with Cursor, Codex,
  Claude Code, and ZCode via standard SKILL.md discovery. Hand off APK unpack to
  apk-reverse, IL2CPP symbols to rev-u3d-dump, heavy Frida to rev-frida.
when_to_use: >
  User mentions server emulator, private server, game server rewrite, stub
  server, protocol recovery, packet capture, Protobuf decode, IL2CPP, repack APK
  to change API URL, DNS hijack, adb reverse, frp/ngrok tunnel, login handler,
  character list API, offline game, discontinued game revival, or wants a
  step-by-step case folder under cases/<slug>/ with evidence and ENGAGEMENT report.
activation_keywords: server emulator private server protocol recovery IL2CPP protobuf stub server adb reverse frp ngrok mitmproxy frida jadx apktool login handler game server rewrite packet capture wire protocol Unity IL2CPP repack APK DNS hijack tunnel multiplayer
---

## ACTION REQUIRED (execute — do not stop at overview)

1. `NOW` Read [references/engagement-os.md](references/engagement-os.md). If no case dir exists, run:
   `bash scripts/init-workspace.sh --slug <slug> --out ./cases/<slug>`
2. `NOW` Run `bash scripts/doctor.sh` and save JSON to `cases/<slug>/00-doctor.json`.
3. `NEXT` If you have an APK, run `bash scripts/triage-client.sh <apk>` → `01-triage.json`, then read [routing.md](routing.md).
4. `ACT` Open **only** the current stage playbook. Finish that stage’s exit criteria before advancing. See [references/phase-gates.md](references/phase-gates.md).

Do not skip workspace setup, skip protocol notes, or commit APKs/pcaps/keys into this skill repo.

---

# Mobile server emulator — CLI playbook

This skill is a **case operating system**, not a ready-made server for one game. Deliverables live in `cases/<slug>/`: evidence, protocol notes, a runnable stub server, and stage reports.

## 1. Read order

| # | File | When |
|---|------|------|
| 1 | `references/engagement-os.md` | Create dirs, name evidence |
| 2 | `tool-index.md` + `scripts/doctor.sh` | Tool gaps |
| 3 | `routing.md` + `references/engine-fingerprint.md` | After triage |
| 4 | Current stage playbook | One at a time |
| 5 | `references/failure-catalog.md` | When stuck |
| 6 | `templates/report/ENGAGEMENT.md` | Stage close-out |

Playbooks:

- [playbooks/01-triage.md](playbooks/01-triage.md)
- [playbooks/02-redirect.md](playbooks/02-redirect.md)
- [playbooks/03-protocol.md](playbooks/03-protocol.md)
- [playbooks/04-server.md](playbooks/04-server.md)
- [playbooks/05-tunnel.md](playbooks/05-tunnel.md)

Topic references (open on demand):

- [client-redirect.md](references/client-redirect.md)
- [unity-il2cpp.md](references/unity-il2cpp.md)
- [protobuf-workflow.md](references/protobuf-workflow.md)
- [wire-protocol.md](references/wire-protocol.md)
- [login-sequence.md](references/login-sequence.md)
- [handler-contract.md](references/handler-contract.md)
- [data-model.md](references/data-model.md)
- [fake-server-patterns.md](references/fake-server-patterns.md)
- [tunnel-multiplayer.md](references/tunnel-multiplayer.md)
- [open-source-catalog.md](references/open-source-catalog.md)
- [community-skills.md](references/community-skills.md)

## 2. Stage machine

```
Workspace → 0 Triage → 1 Redirect → 2 Protocol → 3 Server → 4 Tunnel
              ↑________ failure-catalog: still hits official / parse fail / crash ________|
```

| Stage | Entry | Exit evidence | Playbook |
|-------|-------|---------------|----------|
| 0 | `triage-client.sh` | `01-triage.json` | 01 |
| 1 | `decode-client.sh` / `patch-endpoint.sh` | Client logs show your host | 02 |
| 2 | `capture-traffic.sh` / `proto-extract.sh` | ≥1 reproducible message note | 03 |
| 3 | `server-bootstrap.sh` | Login success + readable character | 04 |
| 4 | `tunnel-setup.sh` | Port map + second device connects | 05 |

Details: [phase-gates.md](references/phase-gates.md).

## 3. Case workspace

```bash
bash scripts/init-workspace.sh --slug mygame --title "My Game" --out ./cases/mygame
```

Structure: [engagement-os.md](references/engagement-os.md).

## 4. Scripts

| Script | Output |
|--------|--------|
| `doctor.sh` | Tool presence JSON |
| `init-workspace.sh` | Case skeleton + report draft |
| `triage-client.sh` | Engine / URLs / recommended_path |
| `decode-client.sh` | `jadx_out` + `apktool_out` |
| `patch-endpoint.sh` | URL report or assets/DNS plan |
| `capture-traffic.sh` | Proxy + cert steps |
| `proto-extract.sh` | Protobuf class hints |
| `frida-hook-run.sh` | Inject hook script |
| `server-bootstrap.sh` | Python or Node stub |
| `tunnel-setup.sh` | frp or ngrok config |

Bootstrap commands: [tool-index.md](tool-index.md). On script failure, paste stderr into `cases/<slug>/logs/`.

## 5. Protocol notes

Copy [templates/protocol/PACKET.md](templates/protocol/PACKET.md) to `cases/<slug>/protocol/PKT-###.md` for each confirmed message. Handlers without a note are incomplete.

Implement per [handler-contract.md](references/handler-contract.md). Login order: [login-sequence.md](references/login-sequence.md).

## 6. When stuck

Use [failure-catalog.md](references/failure-catalog.md) by symptom ID. Two attempts with no new evidence → stop changing code; go back one stage and add evidence.

## 7. Handoffs

| Slice | Skill |
|-------|-------|
| APK unpack / smali / resign | `apk-reverse` |
| IL2CPP symbols | `rev-u3d-dump` |
| Frida scripts | `rev-frida` |
| Crypto depth | `protocol-cryptanalysis` |
| UI automation only | `game-automation-scripting` |

## 8. Definition of done

Fill [templates/report/ENGAGEMENT.md](templates/report/ENGAGEMENT.md) with:

- Triage JSON path
- Official vs local host mapping
- Protocol note list
- Implemented handlers + unknown messages
- Start command and ports
- Open items and next evidence

## 9. Do not

- Skip workspace or triage
- Commit keys, pcaps, or APKs into this repo
- Invent protobuf field numbers without samples
- Replace failure-catalog steps with “try again”
