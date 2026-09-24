# Stage 3 · Minimal server patterns

Follow [playbooks/04-server.md](../playbooks/04-server.md), [handler-contract.md](handler-contract.md), [data-model.md](data-model.md), [login-sequence.md](login-sequence.md).

Goal: minimal code so the client accepts login and progresses.

## Closure priority

1. Login → success + token
2. Character list or empty + create
3. Enter world → level, gold, map id
4. Static assets — CDN may 404 if core APIs return 200

Implement handlers as the client crashes or logs missing packets — not hundreds upfront.

## Architecture

```
Transport → Framing → Router → Service → Repository (SQLite)
```

## Handler types

| Type | Use |
|------|-----|
| Echo | empty protobuf |
| Stub | fixed `{ code: 0, gold: N }` |
| Proxy | static CDN only |
| Stateful | read/write SQLite |

## Language choice

| Lang | Fit |
|------|-----|
| Python FastAPI | HTTP JSON prototypes |
| Node Express | WebSocket + JSON |
| Go | high-concurrency TCP |
| C# ASP.NET | Unity-like stacks |

## Bootstrap

```bash
bash scripts/server-bootstrap.sh --slug mygame --lang python --out ./mygame_server
```

## Debug loop

1. Client request → log unknown packet/path
2. Match capture hex or public emulator
3. Add handler, restart, repeat until past login screen
