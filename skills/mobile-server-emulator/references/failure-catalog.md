# Failure catalog

Match symptom ID first, change one thing, log command + output under `logs/`. After two attempts with no new evidence, switch tactic or revisit the prior stage — do not end the engagement.

## Redirect `F-REDIRECT`

| ID | Symptom | Next step |
|----|---------|-----------|
| F-REDIRECT-01 | No game traffic in proxy | Check proxy IP/port; emulator system proxy; try raw TCP capture |
| F-REDIRECT-02 | System traffic only | Game may use direct IP — inspect connect targets; DNS may be useless |
| F-REDIRECT-03 | Cert error then silence | Cert not in trust store or app pins custom store — log exact error, find trust config |
| F-REDIRECT-04 | Assets patched but old host | Host in `.so` or hot-update bundle — follow engine fingerprint |
| F-REDIRECT-05 | Login server OK, game server official | Patch next-hop in login response — login-sequence step 7 |
| F-REDIRECT-06 | Emulator only | `adb reverse` is device-local — use LAN IP or DNS on phone |

## Protocol `F-PROTO`

| ID | Symptom | Next step |
|----|---------|-----------|
| F-PROTO-01 | Body looks random | Separate compression vs encryption vs misaligned frame — log first 16 bytes + length |
| F-PROTO-02 | `protoc --decode_raw` fails | Try stripping 2/4-byte header; record working header size in PKT |
| F-PROTO-03 | Field numbers OK, strings garbage | Endianness or UTF-16 — keep raw hex in PKT |
| F-PROTO-04 | Client disconnects on response | Diff length, required fields one at a time |
| F-PROTO-05 | JSON field names wrong | Match client parser names in server, not guesses |

## Server `F-SERVER`

| ID | Symptom | Next step |
|----|---------|-----------|
| F-SERVER-01 | Port not listening | `lsof -nP -iTCP:<port> -sTCP:LISTEN` → logs |
| F-SERVER-02 | Listening but client timeout | Firewall, bind address, wrong port in client |
| F-SERVER-03 | Unknown request spam | One PKT per message + named handler — no permanent catch-all |
| F-SERVER-04 | Progress lost on restart | SQLite under `cases/<slug>/server/` |
| F-SERVER-05 | Heartbeat stop → login screen | Reply at observed interval; document in REPORT |

## Tunnel `F-TUNNEL`

| ID | Symptom | Next step |
|----|---------|-----------|
| F-TUNNEL-01 | Local OK, frp fails | Match frpc remote port to client config |
| F-TUNNEL-02 | Random drops | Heartbeat vs tunnel timeout — fix one at a time |
| F-TUNNEL-03 | Peer connects but empty state | Same SQLite file for all clients |

## Log format

```text
symptom: F-PROTO-04
evidence: logs/2026-09-24-login.txt
change: server/handlers/login.py add field 3
result: still disconnect / reached character select
new evidence: protocol/PKT-004.md
```
