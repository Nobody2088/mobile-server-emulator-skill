# Case operating system

One target → one directory. The case dir is the single source of truth. This skill repo holds methodology only.

## 1. Create

```bash
bash scripts/init-workspace.sh \
  --slug mygame \
  --title "My Game" \
  --out ./cases/mygame
```

`slug`: lowercase letters, digits, hyphens only.

## 2. Layout

```text
cases/<slug>/
├── 00-doctor.json
├── 01-triage.json
├── REPORT.md
├── client/
│   ├── apk/
│   ├── jadx_out/
│   ├── apktool_out/
│   ├── il2cpp/
│   ├── endpoints.md
│   └── redirect-notes.md
├── docs/
│   ├── index.md
│   ├── endpoints.md
│   ├── boot-sequence.md
│   └── master-data/
├── capture/
│   ├── notes.md
│   └── samples/
├── protocol/
│   └── PKT-001.md
├── server/
├── tunnel/
└── logs/
```

## 3. Evidence IDs

| Prefix | Meaning |
|--------|---------|
| `EV-DOC` | Environment |
| `EV-TRI` | Triage |
| `EV-CAT` | Unpack catalog |
| `EV-RED` | Redirect works |
| `EV-PKT` | One message |
| `EV-SRV` | Handler behavior |
| `EV-TUN` | Port mapping |

Reference IDs in notes — not “we saw it earlier in chat”.

## 4. Naming

- Record package, version, ABI at top of `REPORT.md`.
- Host table columns: `official`, `local/tunnel`, `evidence id`.
- Handler names match message names: `LoginReq` → `handle_login_req`.

## 5. Redaction before sharing

Strip tokens, cookies, payment fields, real player IDs, full pcaps. Keep lengths, field numbers, types, and synthetic test values.

## 6. Handoff to a new session

Provide:

1. `REPORT.md` current stage
2. Latest failure log under `logs/`
