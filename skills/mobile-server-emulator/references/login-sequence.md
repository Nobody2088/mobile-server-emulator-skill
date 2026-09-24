# Login and enter-world sequence

Clients care about **order** and **missing fields**, not API count.

## Typical order

```text
1. Version / hotfix manifest
2. Login server handshake
3. Account validation
4. Session token
5. Realm / server list
6. Character list or create
7. Game server connect (often new host:port)
8. Full or delta player data
9. Heartbeat loop
10. Gameplay messages (add on crash)
```

Step 7 is the usual “login OK but cannot enter world” failure — map both login and game hosts in `redirect-notes.md`.

## Six fields per hop (in each PKT)

1. Direction C→S or S→C
2. Transport (HTTP path / TCP port / WS)
3. Previous message ID
4. Client behavior on success
5. Client error text on failure
6. Current server response

## Minimal “in game” definition

- Login accepted (no immediate network error)
- ≥1 character/player payload
- Heartbeat stable for 3 intervals
- Main UI config present or client tolerates missing config (with evidence)

## Heartbeat

Document interval, initiator (client/server), timeout behavior. Implement in server read loop or timer — do not sleep blindly.

## Multi-connection patterns

| Pattern | Server shape |
|---------|--------------|
| Single host | one listener |
| Login + game | two ports or two processes |
| Gateway | gateway handler first |

Login response next-hop must point at **your** hosts after stage 1.
