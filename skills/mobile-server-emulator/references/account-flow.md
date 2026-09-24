# Register, login, and create character

Checked against public server shapes, not one game's opcodes:

- Wukong login service: `POST /login` returns `userId`, login token, server list, and roles; `POST /createRole` checks that token; `POST /enterGame` returns the gateway host, port, and a second gate token.
- Lunar Tear auth-server: registration and login are a separate HTTP port. The game server only trusts tokens that auth-server signed. A guest client may create an empty account that is later bound to a username. The account nickname is not the in-game character name.
- Channel SDK login (U8 / QuickSDK style): the client arrives with a channel `uid` and `token`. A deduced server does not call the real channel. It accepts that pair once, stores your own `userId`, and issues your own token. Record the channel fields the client still sends.

Write one `protocol/PKT-*.md` per hop. Field names below are the checklist. Use the names in `dump.cs` or the captured message, not these English labels, when they differ.

## Order

```text
register or guest create
  → login
    → server list
      → character list
        → create character (only if the list is empty or the client asks)
          → enter game
            → gateway auth with the gate token
              → full character blob
                → heartbeat
```

Login that returns success but omits the next host, the role list, or the gate token stops the client on the login screen.

## 1. Register

Seen as a dedicated register message, or as login with "create if missing".

Request fields to capture:

- username or channel uid
- password, or channel token
- device id
- platform (`android` / `ios`)
- channel id, when present

Response fields the client usually reads:

- user id
- whether this account is new
- login token
- error text for duplicate name and bad password

Store the password only as a hash in the case database. Reject a second register of the same username with the same error string the client shows.

Guest login: the client sends a device id and no password. Create the account, return `newAccount`, and note a later bind/register message if `dump.cs` has one.

## 2. Login

Request:

- username, uid, or device id
- password or token
- server id, if the client already picked a realm

Checks, in order:

1. Required fields present
2. One login at a time for that account (a second login kicks or returns "already online")
3. Account exists, or create it when the client uses login-as-register
4. Password or token matches

Response:

- user id
- login token (short lived; create-role and enter-game must send it back)
- server list: id, name, status (`normal` / `full` / `closed`), and the gateway host and port
- character list for that server: id, name, level, class or avatar id
- the gateway host and port must be your LAN IP or domain, never the official host

The server list entry is how the client learns the next connection. If you only patch the APK and the login response still names the official gateway, the client leaves your server.

## 3. Create character

Requires a valid login token. Do not create a role for an unknown account.

Request:

- user id and login token
- server id
- character name
- class, gender, or avatar id from `docs/master-data/characters.md`

Checks:

- token matches the account
- server status is `normal`
- name length and character set match what the client enforces
- class or avatar id exists in the catalog
- role count is under the limit the client expects (record the limit from `dump.cs` or a failed packet)
- same account cannot create two roles in the same second (the client retries)

Initial row:

- role id you generate
- level 1
- starter map id from `docs/master-data/maps.md`
- starter items only if a table lists them

Response:

- role id, name, level, class or avatar
- the new list so the client can select it without a second query

## 4. Enter game

Request: user id, login token, role id, server id.

Response:

- gate host and port (your host)
- gate token, different from the login token
- role id the gateway will load

The client then opens the game connection and sends the gate token. The gateway checks the token, loads that role, and answers with the full or delta player blob. A wrong role id or a token from another account closes the socket.

Reconnect uses the gate token, not the password. Document the timeout. If the client retries enter-game after a drop, accept the same role id and return a new gate token.

## Tokens

| Token | Issued by | Used for |
|-------|-----------|----------|
| login token | login | create character, enter game, server list |
| gate token | enter game | gateway auth, reconnect |

Both live in the case database or its cache. Do not put them in the APK.

## Case files

- `protocol/PKT-register.md`, `PKT-login.md`, `PKT-server-list.md`, `PKT-create-role.md`, `PKT-enter-game.md`, `PKT-gate-auth.md` when each message exists
- `docs/boot-sequence.md` rows for these hops
- SQLite `account` and `character` rows. See [data-model.md](data-model.md)

## Not done

- Login response with no server list and no role list
- Create-role that accepts a class id absent from the catalog
- Enter-game that points the client at the official gateway
- One shared token for login and gateway when the capture shows two
