# Open-source server emulator search

Search GitHub **before** writing handlers from scratch.

## Queries

```
"<game english name>" server emulator
"<game english name>" private server
"<package name>" protobuf
"<game name>" revival project
game server emulator android
```

## Example archetypes (architecture reference only)

| Archetype | Direction |
|-----------|-----------|
| Unity IL2CPP + TCP | Frida redirect + custom TCP server |
| Protobuf + .NET | packet handlers + `.proto` tree |
| Go custom framing | transport + protobuf layers |
| Blowfish HTTP + Socket.IO | encrypted REST + realtime room |
| DNS hijack + Python | minimal HTTP stub |

## How to use a hit

1. Read README for client patch + server start
2. Mirror handler directory layout
3. Do not assume encryption matches — verify version
4. Record upstream commit hash and version in `REPORT.md`

## No hit

Follow this skill’s four stages; implement login handler first, extend from client errors.
