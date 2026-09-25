# mobile-server-emulator-skill

Universal Agent skill for **mobile game server emulator development** — a case-based workflow (redirect client → capture protocol → stub server → tunnel), not a single-game bypass.

**Includes:** 12 bash scripts, stage playbooks from triage through tunnel (including unpack), stage exit checklists, protocol note templates, failure catalog, Python/Node server stubs, Frida hooks. **Engines:** Unity IL2CPP, Cocos, native Java/OkHttp. **Works with:** Cursor, Codex, Claude Code, ZCode CLI, [Agent Skills](https://skills.sh/).

The skill directory ships `_meta.json` with a full display description and activation keywords so ZCode/Cursor skill pickers show rich text instead of the generic “skill in group X” placeholder.

## What it covers

- Client unpack into endpoint and master-data docs (characters, monsters, maps, activities, items, skills, quests)
- Endpoint redirection to a LAN IP or a domain (gateway and update, not only login)
- Traffic capture and protocol recovery (HTTPS, Protobuf, custom framing)
- Stub server for register, login token, create character, and enter-game gate token
- Tunneling and multiplayer (frp, ngrok, adb reverse)

## Workflow

1. `scripts/init-workspace.sh` — create `cases/<slug>/`
2. `scripts/doctor.sh` + `scripts/triage-client.sh`
3. Playbooks `01-triage`, `01-unpack`, then `02` through `05`, with phase gates in `references/phase-gates.md`
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
├── playbooks/       # Triage, unpack, redirect, protocol, server, tunnel
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
