# Playbook 01 · Triage

Goal: engine, version, official host candidates, next path. No repacking yet.

## Steps

1. Place APK under `cases/<slug>/client/apk/`.
2. Run:

```bash
bash scripts/doctor.sh | tee cases/<slug>/00-doctor.json
bash scripts/triage-client.sh cases/<slug>/client/apk/game.apk | tee cases/<slug>/01-triage.json
```

3. If `aapt` exists:

```bash
aapt dump badging cases/<slug>/client/apk/game.apk | tee cases/<slug>/logs/badging.txt
```

4. Review with [engine-fingerprint.md](../references/engine-fingerprint.md). Document in `client/engine.md` if triage differs.
5. Search GitHub per [open-source-catalog.md](../references/open-source-catalog.md). Record URL or “none” in `REPORT.md`.
6. Read [routing.md](../routing.md) and open [01-unpack.md](01-unpack.md) next. Do not redirect yet.

## Done when

- `01-triage.json` has `package`, `engine`, `recommended_path`
- Version triple recorded
- Open-source search recorded

## Stop

- APK is not a zip — do not run jadx
