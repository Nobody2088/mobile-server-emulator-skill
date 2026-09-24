# Data model

One SQLite file per case. Keep columns the client actually reads; stash the rest in JSON until stable.

## Minimal schema

```sql
CREATE TABLE account (
  id INTEGER PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  password_hash TEXT,
  device_id TEXT,
  channel_uid TEXT,
  login_token TEXT,
  created_at TEXT NOT NULL
);

CREATE TABLE character (
  id INTEGER PRIMARY KEY,
  account_id INTEGER NOT NULL REFERENCES account(id),
  server_id TEXT NOT NULL DEFAULT '1',
  name TEXT NOT NULL,
  level INTEGER NOT NULL DEFAULT 1,
  class_id TEXT,
  map_id TEXT,
  gate_token TEXT,
  blob_json TEXT NOT NULL DEFAULT '{}'
);

CREATE TABLE inbox (
  id INTEGER PRIMARY KEY,
  account_id INTEGER NOT NULL,
  message_name TEXT NOT NULL,
  body_json TEXT NOT NULL,
  created_at TEXT NOT NULL
);
```

Promote fields from `blob_json` to columns after three handlers use them.

## Ownership

| Data | Writer | Reader |
|------|--------|--------|
| account / character | login, create handlers | all authenticated handlers |
| inbox | unknown message capture | human protocol work |

Game state stays in SQLite — not in frp config or client APK.

Master tables (characters, monsters, maps, items, skills, quests, activities) are read-only copies of `docs/master-data/`. Key them by those IDs. Do not insert an ID the catalog does not list. Account and character rows stay writable.

## Identity

Use token/uid/session field names from PKT notes for post-login auth.

## Multiplayer

One DB, `account_id` isolation. Add `realm_id` only if protocol has realms.

Backup DB before migrations; keep `server/schema.sql` in the case dir.
