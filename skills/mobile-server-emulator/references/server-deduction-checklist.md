# Server deduction checklist

A handler is not guessable until the case folder contains the items below. Patterns come from public revival projects (host rewrite plus master tables), not from one game's patches.

Sources to mirror, not copy:

- Lunar Tear: metadata hostnames rewritten to a LAN IP; HTTP and gRPC ports kept; server loads `master_data` JSON and asset bundles.
- Witcher Monster Slayer revival: `dump.cs`, asset catalog, boot-sequence doc, static data container, TCP gateway redirect.
- IL2CPP write-ups: `libil2cpp.so` + `global-metadata.dat`, or a runtime dump when metadata is packed; opcode map; handshake; JS/Puerts logic that is absent from `dump.cs`.

## Required before the first handler

### Client identity

- Package name, versionName, versionCode, ABI
- Engine and, for Unity, the Unity version
- Evidence: `01-triage.json`, `client/engine.md`

### Symbols

- `dump.cs` or a Java/smali index
- String table (`stringliteral.json` or grep of unpacked strings)
- Network class names: `Login`, `Gateway`, `Packet`, `Cmd`, protobuf namespaces
- If metadata is encrypted, dump after the runtime decrypts it. Do not treat a failed static Il2CppDumper run as "no symbols."

### Every endpoint

Not one URL. Inventory each of:

- version / update
- hotfix / CDN / Addressables
- gateway
- login
- zone / server list
- game / battle server
- announcement / notice
- remote config

For each row record scheme, host, port, and protocol: HTTP, TCP, WebSocket, or gRPC.

File: `docs/endpoints.md` (also linked from `client/endpoints.md`).

### Boot order

Which call must succeed before the next:

1. Update / version check
2. Register, guest create, or channel login
3. Login token and server list
4. Character list or create character
5. Enter game, then gateway auth
6. Enter map

Account fields: [account-flow.md](account-flow.md).

File: `docs/boot-sequence.md`. A later call that fires before an earlier one succeeds is a missing handler, not a random crash.

### Wire contract

- Opcode or HTTP path
- Request and response fields
- Heartbeat interval and payload
- Session token field name

At least one `protocol/PKT-*.md` for the first login-related message before stage 3.

### Static IDs

The client rejects unknown IDs. Catalog:

- characters
- monsters
- maps
- items
- skills
- quests
- activities

If tables ship inside the APK, the server sends IDs that exist in those tables. If the client downloads tables, the local update/CDN host must serve them.

Files: `docs/master-data/*.md` and `docs/index.md`.

### Redirect target

IPv4, IPv6, or a domain.

- Same-length string patch when the binary stores a fixed host.
- DNS or hosts when the hostname can stay and only the address changes.
- Document hardcoded ports. Some clients keep 443 for gRPC and a separate HTTP port.

## Done when

Every box in this file has a path under `cases/<slug>/` or an explicit "not in this client" note with the search command that found nothing.
