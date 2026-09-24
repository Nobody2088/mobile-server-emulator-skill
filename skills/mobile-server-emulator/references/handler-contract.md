# Handler contract

One message → one function. Transport only frames and logs.

## Layers

```text
accept / HTTP router
  → frame_decode
    → message_decode
      → handler
        → repository (SQLite)
      ← message_encode
    ← frame_encode
```

No socket reads inside repository; no hand-rolled endianness in HTTP routes.

## Handler shape

```text
handle_<message>(ctx) -> ok | protocol_error | unimplemented
```

| Result | When |
|--------|------|
| `ok` | Body matches PKT note |
| `protocol_error` | Decode failed — log, do not fake success |
| `unimplemented` | Known message, logic pending — log name; return explicit stub per PKT |

List every `unimplemented` in `REPORT.md`.

## Idempotency

Deduplicate login/reward/create by client seq or business id when observed.

## Logging line

```text
ts request_id dir message bytes result account_id
```

Never log full tokens — length + prefix/suffix only.

## Templates

After `server-bootstrap.sh`, rename routes/fields to match PKT notes. Catch-all routes are for discovery only — replace with named handlers quickly.
