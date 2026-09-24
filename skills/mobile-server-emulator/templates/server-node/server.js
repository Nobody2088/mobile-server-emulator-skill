/**
 * Minimal game server stub — {{SLUG}}
 * Placeholder JSON for register, login, create character, and enter game.
 * Replace paths and field names with the PKT notes.
 */
import crypto from "node:crypto";
import express from "express";

const SLUG = "{{SLUG}}";
const PORT = Number(process.env.PORT || 8080);
const PUBLIC_HOST = process.env.PUBLIC_HOST || "127.0.0.1";
const GATE_PORT = Number(process.env.GATE_PORT || PORT);
const app = express();

const accounts = new Map();
const characters = [];
let nextAccountId = 1;
let nextRoleId = 1;

function newToken(prefix) {
  return `${prefix}-${crypto.randomBytes(8).toString("hex")}`;
}

function serverList() {
  return [{ id: "1", name: "local", status: "normal", host: PUBLIC_HOST, port: GATE_PORT }];
}

function rolesFor(accountId) {
  return characters
    .filter((role) => role.accountId === accountId)
    .map((role) => ({ id: role.id, name: role.name, level: 1, classId: role.classId }));
}

function findAccountByToken(userId, loginToken) {
  const account = accounts.get(userId);
  if (!account || account.loginToken !== loginToken) return null;
  return account;
}

app.use(express.raw({ type: "*/*", limit: "10mb" }));
app.use(express.json({ limit: "10mb" }));

app.get("/health", (_req, res) => {
  res.json({ status: "ok", slug: SLUG, host: PUBLIC_HOST, gatePort: GATE_PORT });
});

app.all(["/api/register", "/register"], (req, res) => {
  const username = String(req.body?.username || req.body?.account || req.body?.deviceId || "guest");
  if ([...accounts.values()].some((account) => account.username === username)) {
    res.json({ code: 1, success: false, message: "username taken" });
    return;
  }
  const id = nextAccountId;
  nextAccountId += 1;
  const loginToken = newToken("login");
  accounts.set(id, { id, username, deviceId: req.body?.deviceId || null, loginToken });
  res.json({
    code: 0,
    success: true,
    userId: id,
    newAccount: true,
    loginToken,
    token: loginToken,
    message: "stub register — replace with the captured envelope",
  });
});

app.all(["/api/login", "/login"], (req, res) => {
  const username = String(req.body?.username || req.body?.account || req.body?.deviceId || "guest");
  let account = [...accounts.values()].find((item) => item.username === username);
  let newAccount = false;
  const loginToken = newToken("login");
  if (!account) {
    const id = nextAccountId;
    nextAccountId += 1;
    account = { id, username, deviceId: req.body?.deviceId || null, loginToken };
    accounts.set(id, account);
    newAccount = true;
  } else {
    account.loginToken = loginToken;
  }
  res.json({
    code: 0,
    success: true,
    userId: account.id,
    newAccount,
    loginToken,
    token: loginToken,
    session_id: loginToken,
    servers: serverList(),
    roles: rolesFor(account.id),
    message: "stub login — replace with the captured envelope",
  });
});

app.all(["/api/role", "/api/role/list"], (req, res) => {
  const userId = req.body?.userId;
  res.json({ code: 0, roles: typeof userId === "number" ? rolesFor(userId) : [] });
});

app.all(["/api/role/create", "/api/createRole", "/createRole"], (req, res) => {
  const loginToken = req.body?.loginToken || req.body?.token;
  const account = findAccountByToken(req.body?.userId, loginToken);
  if (!account) {
    res.json({ code: 1, success: false, message: "login token rejected" });
    return;
  }
  const role = {
    id: nextRoleId,
    accountId: account.id,
    name: String(req.body?.name || "Hero"),
    classId: req.body?.classId || req.body?.avatarId || null,
    gateToken: null,
  };
  nextRoleId += 1;
  characters.push(role);
  res.json({
    code: 0,
    success: true,
    role: { id: role.id, name: role.name, level: 1, classId: role.classId },
    roles: rolesFor(account.id),
    message: "stub create role — classId must exist in docs/master-data",
  });
});

app.all(["/api/enterGame", "/enterGame"], (req, res) => {
  const loginToken = req.body?.loginToken || req.body?.token;
  const account = findAccountByToken(req.body?.userId, loginToken);
  if (!account) {
    res.json({ code: 1, success: false, message: "login token rejected" });
    return;
  }
  const role = characters.find((item) => item.id === req.body?.roleId && item.accountId === account.id);
  if (!role) {
    res.json({ code: 1, success: false, message: "role not found" });
    return;
  }
  role.gateToken = newToken("gate");
  res.json({
    code: 0,
    success: true,
    roleId: role.id,
    host: PUBLIC_HOST,
    port: GATE_PORT,
    gateToken: role.gateToken,
    message: "stub enter game — host must be your LAN IP or domain",
  });
});

app.all("*", (req, res) => {
  console.log(`[UNHANDLED] ${req.method} ${req.path} len=${req.body?.length ?? 0}`);
  res.json({ code: 0, path: req.path, stub: true });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`${SLUG} stub listening on :${PORT} host=${PUBLIC_HOST}`);
});
