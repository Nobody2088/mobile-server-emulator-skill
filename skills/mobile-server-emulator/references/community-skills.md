# Related community skills

| Scenario | Skill | Install |
|----------|-------|---------|
| APK unpack / smali / resign | apk-reverse | `npx skills add zhaoxuya520/reverse-skill --skill apk-reverse -g -y` |
| Unity IL2CPP symbols | rev-u3d-dump | `npx skills add p4nda0s/reverse-skills --skill rev-u3d-dump -g -y` |
| Frida script generation | rev-frida | `npx skills add p4nda0s/reverse-skills --skill rev-frida -g -y` |
| HTTP API extraction | android-reverse-engineering | SimoneAvogadro repo |
| Crypto / protocol depth | protocol-cryptanalysis | local `~/.cursor/skills/` |
| UI automation only | game-automation-scripting | local `~/.cursor/skills/` |

## Combined flow

```
triage-client.sh → apk-reverse decode → rev-u3d-dump
  → capture-traffic + rev-frida → server-bootstrap → tunnel-setup
```
