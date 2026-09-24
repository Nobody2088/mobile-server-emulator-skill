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

## Stage 0b · Unpack

**Enter:** Stage 0 complete. `apktool_out` exists or `decode-client.sh` can create it.

**Exit:**

- [ ] `docs/index.md` lists source path, format, and row count or `unparsed`
- [ ] `docs/endpoints.md` exists; gateway and update rows are filled or marked absent with the search command
- [ ] `docs/boot-sequence.md` exists
- [ ] `docs/master-data/` has characters, monsters, maps, activities, items, skills, quests

**Rollback:** No table hits → record the find command and check Addressables / downloaded CDN before inventing IDs.

## Stage 1 · Redirect

**Enter:** Stage 0b complete.

**Exit:**

- [ ] `client/redirect-notes.md` and `docs/endpoints.md` map official → target for gateway and update, not only login
- [ ] Target is an IPv4, IPv6, or domain, with hardcoded ports noted
- [ ] Runtime proof: logcat, proxy, or connect log shows gateway and update traffic to **your** IP or domain
- [ ] If repacked: file list, old/new values, length check, resign/install command

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
- [ ] Register or guest-create, login, and create-character each have a PKT note or an explicit "client has no such message"
- [ ] Login response includes a login token and a server list whose host is yours
- [ ] Create-character accepts only a class or avatar id listed in `docs/master-data/characters.md`
- [ ] Enter-game returns your gateway host, port, and a gate token
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
