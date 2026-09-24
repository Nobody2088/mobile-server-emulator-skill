# Playbook 04 · Minimal server

Goal: responses match protocol notes, not template field names. Read [fake-server-patterns.md](../references/fake-server-patterns.md), [handler-contract.md](../references/handler-contract.md), [data-model.md](../references/data-model.md).

## Steps

1. If a public emulator matches **your APK version**, reuse its protocol definitions when license allows.
2. `bash scripts/server-bootstrap.sh --slug <slug> --lang python --out cases/<slug>/server`
3. Rename template routes/fields to match PKT notes. Remove wrong placeholders.
4. Add one login-sequence hop at a time; restart server; record result in each PKT.
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

Stage 3 gates in [phase-gates.md](../references/phase-gates.md). No heartbeat observed → do not claim “in game”.
