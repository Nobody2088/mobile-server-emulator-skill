# Playbook 04 · Minimal server

Goal: responses match protocol notes, not template field names. Read [fake-server-patterns.md](../references/fake-server-patterns.md), [handler-contract.md](../references/handler-contract.md), [data-model.md](../references/data-model.md).

## Steps

1. If a public emulator matches **your APK version**, reuse its protocol definitions when they match your build.
2. `bash scripts/server-bootstrap.sh --slug <slug> --lang python --out cases/<slug>/server`
3. Rename template routes/fields to match PKT notes. Remove wrong placeholders.
4. Implement register, login, server list, create character, and enter game in that order. Field list: [account-flow.md](../references/account-flow.md). One hop at a time; restart; record the result in each PKT. The enter-game response must return your gateway host and a gate token.
5. Unknown messages → inbox table or logs → new PKT.
6. Copy SQLite before schema changes.

## Start (example)

```bash
cd cases/<slug>/server
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8080
```

## Exit

Stage 3 exit checklist: [phase-gates.md](../references/phase-gates.md). Verify heartbeat in logs before marking stage 3 complete.
