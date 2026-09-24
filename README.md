# mobile-server-emulator-skill

Universal Agent skill for **mobile game server emulator development** (Server Emulator Development).

Works with Cursor, Codex, Claude Code, ZCode CLI, and any client that supports [Agent Skills](https://skills.sh/).

## What it covers

- Client endpoint redirection (APK, DNS, adb reverse)
- Traffic capture and protocol recovery (HTTPS, Protobuf, custom framing)
- Minimal stub game server (login → character → enter world)
- Tunneling and multiplayer (frp, ngrok, adb reverse)

## Workflow

1. `scripts/init-workspace.sh` — create `cases/<slug>/`
2. `scripts/doctor.sh` + `scripts/triage-client.sh`
3. Playbooks 01→05 with phase gates in `references/phase-gates.md`
4. Close with `templates/report/ENGAGEMENT.md`

## Install

### Global (Cursor / Codex)

```bash
npx skills add Nobody2088/mobile-server-emulator-skill --skill mobile-server-emulator -g -y
```

Or symlink:

```bash
ln -sf ~/skills/mobile-server-emulator-skill/skills/mobile-server-emulator \
  ~/.cursor/skills/mobile-server-emulator
```

### Project-local

```bash
mkdir -p .agents/skills
ln -sf ~/skills/mobile-server-emulator-skill/skills/mobile-server-emulator \
  .agents/skills/mobile-server-emulator
```

## Quick start

```bash
bash skills/mobile-server-emulator/scripts/init-workspace.sh \
  --slug mygame --title "My Game" --out ./cases/mygame

bash skills/mobile-server-emulator/scripts/triage-client.sh /path/to/game.apk

bash skills/mobile-server-emulator/scripts/server-bootstrap.sh \
  --slug mygame --lang python --out ./cases/mygame/server
```

## Layout

```
skills/mobile-server-emulator/
├── SKILL.md
├── tool-index.md
├── routing.md
├── playbooks/       # Stage playbooks 01–05
├── scripts/
├── references/
└── templates/
```

## Related skills

| Task | Skill |
|------|-------|
| APK unpack / smali | `apk-reverse` (zhaoxuya520/reverse-skill) |
| IL2CPP symbols | `rev-u3d-dump` (p4nda0s/reverse-skills) |
| Frida scripts | `rev-frida` (p4nda0s/reverse-skills) |

## License

MIT — see [LICENSE](LICENSE).
