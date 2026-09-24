# Agent entry

This repo ships the **mobile-server-emulator** skill (case-based workflow v0.2).

For server emulator, protocol recovery, or stub server tasks, read:

```
skills/mobile-server-emulator/SKILL.md
```

Then open **only** the current stage playbook under `playbooks/0N-*.md`.

Case artifacts live under the caller’s `cases/<slug>/` directory. Do not commit APKs, pcaps, or keystores into this repo.

## Routing

| User intent | Entry |
|-------------|-------|
| Server emulator / private server | `SKILL.md` four-stage workflow |
| APK-only unpack / smali | hand off to `apk-reverse` |
| Unity IL2CPP | `references/unity-il2cpp.md` + `rev-u3d-dump` |
| Capture / crypto protocol | `references/protobuf-workflow.md` |
