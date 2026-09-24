# Playbook 01b · Unpack catalog

Goal: write the client's endpoints and static tables into `cases/<slug>/docs/` before any redirect. Read [client-catalog.md](../references/client-catalog.md) and [server-deduction-checklist.md](../references/server-deduction-checklist.md).

Enter after triage. Do not repack in this stage.

## Steps

1. Decode if `apktool_out` is missing:

```bash
bash scripts/decode-client.sh cases/<slug>/client/apk/game.apk --out cases/<slug>/client
```

2. Catalog tables and endpoints:

```bash
bash scripts/catalog-client.sh \
  --dir cases/<slug>/client/apktool_out \
  --out cases/<slug>/docs

bash scripts/catalog-endpoints.sh \
  --dir cases/<slug>/client/apktool_out \
  --out cases/<slug>/docs/endpoints.md
```

3. Unity IL2CPP: run Il2CppDumper on `libil2cpp.so` plus `global-metadata.dat`. Save `dump.cs` and `stringliteral.json` under `client/il2cpp/`. If metadata is packed, dump it after the runtime decrypts it, then re-run the dumper. See [unity-il2cpp.md](../references/unity-il2cpp.md).

4. Fill `docs/master-data/*.md` from the index and `dump.cs`. One real ID is enough to prove the file is a table. Write `unknown` and the search command when a section is absent.

5. Draft `docs/boot-sequence.md`: update, gateway, login, character, enter-map. Mark any step you have not seen yet as `TODO`.

6. Copy `docs/endpoints.md` notes into `client/redirect-notes.md` roles (update, cdn, gateway, login, zone, game).

## Done when

- `docs/index.md` lists source path, format, and row count (or `unparsed`)
- `docs/endpoints.md` exists and raw hits are classified or marked unmatched
- `docs/boot-sequence.md` exists
- Master-data files exist for characters, monsters, maps, activities, items, skills, quests

## Stop

- APK is not a zip
- Do not invent IDs that are not in the client files or `dump.cs`
