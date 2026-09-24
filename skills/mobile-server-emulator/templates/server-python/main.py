"""
Minimal preservation server stub — {{SLUG}}
Replace handlers with real protocol from capture / open-source reference.
"""
from __future__ import annotations

import json
import sqlite3
from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI, Request, Response

DB_PATH = Path(__file__).parent / "{{SLUG}}.sqlite"
SLUG = "{{SLUG}}"


def init_db() -> None:
    conn = sqlite3.connect(DB_PATH)
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS accounts (
            id INTEGER PRIMARY KEY,
            username TEXT UNIQUE,
            token TEXT,
            gold INTEGER DEFAULT 999999,
            level INTEGER DEFAULT 100
        )
        """
    )
    conn.commit()
    conn.close()


@asynccontextmanager
async def lifespan(_: FastAPI):
    init_db()
    yield


app = FastAPI(title=f"{SLUG} emulator", lifespan=lifespan)


@app.get("/health")
async def health():
    return {"status": "ok", "slug": SLUG}


@app.post("/api/login")
@app.post("/login")
async def login(request: Request):
    body = await request.body()
    try:
        data = json.loads(body) if body else {}
    except json.JSONDecodeError:
        data = {"raw_len": len(body)}

    username = data.get("username") or data.get("account") or "preservation"
    token = f"stub-token-{username}"

    conn = sqlite3.connect(DB_PATH)
    conn.execute(
        "INSERT OR REPLACE INTO accounts (username, token, gold, level) VALUES (?, ?, 999999, 100)",
        (username, token),
    )
    conn.commit()
    conn.close()

    return {
        "code": 0,
        "success": True,
        "token": token,
        "session_id": token,
        "message": "stub login — replace with real protobuf/JSON envelope",
    }


@app.get("/api/role")
@app.post("/api/role/list")
async def role_list(request: Request):
    return {
        "code": 0,
        "roles": [
            {
                "id": 1,
                "name": "PreservationHero",
                "level": 100,
                "gold": 999999,
                "diamond": 999999,
            }
        ],
    }


@app.api_route("/{path:path}", methods=["GET", "POST", "PUT", "DELETE"])
async def catch_all(path: str, request: Request):
    body = await request.body()
    print(f"[UNHANDLED] {request.method} /{path} len={len(body)}")
    return Response(
        content=json.dumps({"code": 0, "path": path, "stub": True}),
        media_type="application/json",
    )
