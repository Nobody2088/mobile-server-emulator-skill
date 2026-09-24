# Login and enter-world sequence

Clients care about **order** and **missing fields**, not API count.

## Typical order

```text
1. Version / hotfix manifest
2. Register, guest create, or channel uid+token
3. Login → user id + login token
4. Realm / server list (host and port must be yours)
5. Character list
6. Create character when the list is empty
7. Enter game → gate host, port, and gate token
8. Gateway auth on the game connection
9. Full or delta player data
10. Heartbeat loop
11. Gameplay messages (add on crash)
```

Field checklist for register, login, create character, and enter game: [account-flow.md](account-flow.md).

Step 7 is the usual “login OK but cannot enter world” failure. The enter-game response must name your gateway, not only the APK patch.

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
