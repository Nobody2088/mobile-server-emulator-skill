/**
 * Minimal preservation server stub — {{SLUG}}
 */
import express from "express";

const SLUG = "{{SLUG}}";
const PORT = process.env.PORT || 8080;
const app = express();

app.use(express.raw({ type: "*/*", limit: "10mb" }));
app.use(express.json({ limit: "10mb" }));

app.get("/health", (_req, res) => {
  res.json({ status: "ok", slug: SLUG });
});

app.all(["/api/login", "/login"], (req, res) => {
  const username = req.body?.username || req.body?.account || "preservation";
  const token = `stub-token-${username}`;
  res.json({
    code: 0,
    success: true,
    token,
    session_id: token,
    message: "stub login — replace with real envelope",
  });
});

app.all(["/api/role", "/api/role/list"], (_req, res) => {
  res.json({
    code: 0,
    roles: [
      { id: 1, name: "PreservationHero", level: 100, gold: 999999, diamond: 999999 },
    ],
  });
});

app.all("*", (req, res) => {
  console.log(`[UNHANDLED] ${req.method} ${req.path} len=${req.body?.length ?? 0}`);
  res.json({ code: 0, path: req.path, stub: true });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`${SLUG} stub listening on :${PORT}`);
});
