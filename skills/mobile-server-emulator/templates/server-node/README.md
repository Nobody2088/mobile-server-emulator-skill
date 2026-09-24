# {{SLUG}} — Node stub server

```bash
npm install
npm start
```

Default port 8080. Set `PORT=9000 npm start` if needed.

`PUBLIC_HOST` is the LAN IP or domain returned in the server list and enter-game response. `GATE_PORT` defaults to `PORT`.

Placeholder routes: `/api/register`, `/api/login`, `/api/role/create`, `/api/enterGame`. Replace them with the captured envelope. `loginToken` and `gateToken` are different. The store is in memory.
