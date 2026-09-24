"""
Minimal game server stub — {{SLUG}}

Placeholder JSON for register, login, create character, and enter game.
Replace paths and field names with the PKT notes. Class ids must come from
docs/master-data, not from this file.
"""
from __future__ import annotations

import json
import os
import secrets
import sqlite3
from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI, Request, Response

DB_PATH = Path(__file__).parent / "{{SLUG}}.sqlite"
SLUG = "{{SLUG}}"
PUBLIC_HOST = os.environ.get("PUBLIC_HOST", "127.0.0.1")
GATE_PORT = int(os.environ.get("GATE_PORT", "8080"))


def connect() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


def init_db() -> None:
    conn = connect()
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS accounts (
            id INTEGER PRIMARY KEY,
            username TEXT UNIQUE,
            device_id TEXT,
            login_token TEXT
        )
        """
    )
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS characters (
            id INTEGER PRIMARY KEY,
            account_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            class_id TEXT,
            gate_token TEXT
        )
        """
    )
    conn.commit()
    conn.close()


def new_token(prefix: str) -> str:
    return f"{prefix}-{secrets.token_hex(8)}"


def read_json(body: bytes) -> dict:
    if not body:
        return {}
    try:
        data = json.loads(body)
    except json.JSONDecodeError:
        return {"raw_len": len(body)}
    return data if isinstance(data, dict) else {}


def server_list() -> list[dict]:
    return [
        {
            "id": "1",
            "name": "local",
            "status": "normal",
            "host": PUBLIC_HOST,
            "port": GATE_PORT,
        }
    ]


def roles_for(account_id: int) -> list[dict]:
    conn = connect()
    rows = conn.execute(
        "SELECT id, name, class_id FROM characters WHERE account_id = ?",
        (account_id,),
    ).fetchall()
    conn.close()
    return [
        {"id": row["id"], "name": row["name"], "level": 1, "classId": row["class_id"]}
        for row in rows
    ]


@asynccontextmanager
async def lifespan(_: FastAPI):
    init_db()
    yield


app = FastAPI(title=f"{SLUG} emulator", lifespan=lifespan)


@app.get("/health")
async def health():
    return {"status": "ok", "slug": SLUG, "host": PUBLIC_HOST, "gatePort": GATE_PORT}


@app.post("/api/register")
@app.post("/register")
async def register(request: Request):
    data = read_json(await request.body())
    username = str(data.get("username") or data.get("account") or data.get("deviceId") or "guest")
    token = new_token("login")
    conn = connect()
    existing = conn.execute("SELECT id FROM accounts WHERE username = ?", (username,)).fetchone()
    if existing:
        conn.close()
        return {"code": 1, "success": False, "message": "username taken"}
    conn.execute(
        "INSERT INTO accounts (username, device_id, login_token) VALUES (?, ?, ?)",
        (username, data.get("deviceId"), token),
    )
    conn.commit()
    account_id = conn.execute("SELECT id FROM accounts WHERE username = ?", (username,)).fetchone()["id"]
    conn.close()
    return {
        "code": 0,
        "success": True,
        "userId": account_id,
        "newAccount": True,
        "loginToken": token,
        "token": token,
        "message": "stub register — replace with the captured envelope",
    }


@app.post("/api/login")
@app.post("/login")
async def login(request: Request):
    data = read_json(await request.body())
    username = str(data.get("username") or data.get("account") or data.get("deviceId") or "guest")
    token = new_token("login")
    conn = connect()
    row = conn.execute("SELECT id FROM accounts WHERE username = ?", (username,)).fetchone()
    if row is None:
        conn.execute(
            "INSERT INTO accounts (username, device_id, login_token) VALUES (?, ?, ?)",
            (username, data.get("deviceId"), token),
        )
        conn.commit()
        account_id = conn.execute("SELECT id FROM accounts WHERE username = ?", (username,)).fetchone()["id"]
        new_account = True
    else:
        account_id = row["id"]
        conn.execute("UPDATE accounts SET login_token = ? WHERE id = ?", (token, account_id))
        conn.commit()
        new_account = False
    conn.close()
    return {
        "code": 0,
        "success": True,
        "userId": account_id,
        "newAccount": new_account,
        "loginToken": token,
        "token": token,
        "session_id": token,
        "servers": server_list(),
        "roles": roles_for(account_id),
        "message": "stub login — replace with the captured envelope",
    }


@app.get("/api/role")
@app.post("/api/role/list")
async def role_list(request: Request):
    data = read_json(await request.body())
    account_id = data.get("userId")
    if not isinstance(account_id, int):
        return {"code": 0, "roles": []}
    return {"code": 0, "roles": roles_for(account_id)}


@app.post("/api/role/create")
@app.post("/api/createRole")
@app.post("/createRole")
async def create_role(request: Request):
    data = read_json(await request.body())
    user_id = data.get("userId")
    login_token = data.get("loginToken") or data.get("token")
    name = str(data.get("name") or "Hero")
    class_id = data.get("classId") or data.get("avatarId")
    conn = connect()
    account = conn.execute(
        "SELECT id FROM accounts WHERE id = ? AND login_token = ?",
        (user_id, login_token),
    ).fetchone()
    if account is None:
        conn.close()
        return {"code": 1, "success": False, "message": "login token rejected"}
    conn.execute(
        "INSERT INTO characters (account_id, name, class_id) VALUES (?, ?, ?)",
        (account["id"], name, None if class_id is None else str(class_id)),
    )
    conn.commit()
    role_id = conn.execute("SELECT last_insert_rowid() AS id").fetchone()["id"]
    conn.close()
    return {
        "code": 0,
        "success": True,
        "role": {"id": role_id, "name": name, "level": 1, "classId": class_id},
        "roles": roles_for(account["id"]),
        "message": "stub create role — classId must exist in docs/master-data",
    }


@app.post("/api/enterGame")
@app.post("/enterGame")
async def enter_game(request: Request):
    data = read_json(await request.body())
    user_id = data.get("userId")
    login_token = data.get("loginToken") or data.get("token")
    role_id = data.get("roleId")
    conn = connect()
    account = conn.execute(
        "SELECT id FROM accounts WHERE id = ? AND login_token = ?",
        (user_id, login_token),
    ).fetchone()
    if account is None:
        conn.close()
        return {"code": 1, "success": False, "message": "login token rejected"}
    role = conn.execute(
        "SELECT id FROM characters WHERE id = ? AND account_id = ?",
        (role_id, account["id"]),
    ).fetchone()
    if role is None:
        conn.close()
        return {"code": 1, "success": False, "message": "role not found"}
    gate_token = new_token("gate")
    conn.execute("UPDATE characters SET gate_token = ? WHERE id = ?", (gate_token, role["id"]))
    conn.commit()
    conn.close()
    return {
        "code": 0,
        "success": True,
        "roleId": role["id"],
        "host": PUBLIC_HOST,
        "port": GATE_PORT,
        "gateToken": gate_token,
        "message": "stub enter game — host must be your LAN IP or domain",
    }


@app.api_route("/{path:path}", methods=["GET", "POST", "PUT", "DELETE"])
async def catch_all(path: str, request: Request):
    body = await request.body()
    print(f"[UNHANDLED] {request.method} /{path} len={len(body)}")
    return Response(
        content=json.dumps({"code": 0, "path": path, "stub": True}),
        media_type="application/json",
    )
