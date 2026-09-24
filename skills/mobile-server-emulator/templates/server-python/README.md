# {{SLUG}} — Python stub server

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8080 --reload
```

Point client to `http://YOUR_IP:8080` or use `adb reverse tcp:8080 tcp:8080`.

`PUBLIC_HOST` is the LAN IP or domain returned in the server list and enter-game response. `GATE_PORT` defaults to 8080.

Placeholder routes: `/api/register`, `/api/login`, `/api/role/create`, `/api/enterGame`. Replace them with the captured envelope. `loginToken` and `gateToken` are different.
