# Phase gates

Do not advance without exit evidence. Check boxes in `REPORT.md` with evidence IDs.

## Stage 0 · Triage

**Enter:** Case workspace exists.

**Exit:**

- [ ] `01-triage.json` with non-empty `engine`
- [ ] Version triple recorded (versionName, versionCode, ABI)
- [ ] `recommended_path` copied to `REPORT.md`
- [ ] GitHub search per [open-source-catalog.md](open-source-catalog.md) — hit or “none”

**Rollback:** APK not a zip → `unzip -t` before jadx.

## Stage 1 · Redirect

**Enter:** Stage 0 complete.

**Exit:**

- [ ] `client/redirect-notes.md` maps official → target hosts
- [ ] Runtime proof: logcat, proxy, or connect log shows traffic to **your** host
- [ ] If repacked: file list, old/new values, resign/install command

**Rollback:** Still hits official → [failure-catalog.md](failure-catalog.md) `F-REDIRECT-*`. Do not write login handlers yet.

## Stage 2 · Protocol

**Enter:** Traffic reaches your machine or proxy.

**Exit:**

- [ ] ≥1 `protocol/PKT-*.md` with direction, transport, sample structure
- [ ] First login-related message named
- [ ] Encoding chosen: JSON / Protobuf / custom frame / still encrypted

**Rollback:** Ciphertext only → note lengths and call sites; do not guess field numbers.

## Stage 3 · Server

**Enter:** ≥1 login-related PKT note.

**Exit:**

- [ ] Server listening on documented port
- [ ] Login response matches note (status/body)
- [ ] Unknown paths/packet IDs logged, not silently dropped
- [ ] Next post-login message has note or explicit TODO + client error text

**Rollback:** Disconnect after login → compare note fields/endianness (`F-PROTO-*`).

## Stage 4 · Tunnel

**Enter:** Local loopback or `adb reverse` login works.

**Exit:**

- [ ] Port map: local, remote, tool
- [ ] Second network/device connection proof
- [ ] Game state only in server DB, not in tunnel config

**Rollback:** Emulator OK, phone fails → proxy, cert, DNS, ports.

## Global stop

- Same symptom twice with no new evidence
- Missing materials needed for the next hop
