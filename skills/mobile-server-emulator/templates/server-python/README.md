# {{SLUG}} — Python stub server

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8080 --reload
```

Point client to `http://YOUR_IP:8080` or use `adb reverse tcp:8080 tcp:8080`.

Replace `/api/login` and catch-all with real routes from protocol analysis.
