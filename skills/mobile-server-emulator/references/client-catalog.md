# Client catalog

Deep unpack writes what the client already knows into `cases/<slug>/docs/`. The deduced server answers with IDs from these files. It does not invent monsters, maps, or activities.

## Where tables live

| Engine | Typical locations |
|--------|-------------------|
| Unity IL2CPP | `assets/bin/Data`, Addressables catalog, AssetBundles, `global-metadata.dat` strings |
| Cocos / Lua | `assets/**/*.json`, `*.csv`, `*.lua`, `*.xml` |
| Native Java | `assets/`, `res/raw/`, embedded JSON next to Retrofit models |
| Downloaded | Update/CDN response. If the APK has no tables, the local update host must serve them. |

Formats to label in `docs/index.md`: JSON, CSV, XML, AssetBundle, Lua, MessagePack, FlatBuffers, binary blob.

## Sections

`scripts/catalog-client.sh` creates the files. Fill them from `dump.cs` and the source files it lists. One ID per row once the format is known.

| File | Record |
|------|--------|
| `docs/master-data/characters.md` | id, name, role or class, source file |
| `docs/master-data/monsters.md` | id, name, map or stage, source file |
| `docs/master-data/maps.md` | id, scene name, enter opcode or path |
| `docs/master-data/activities.md` | id, name, open condition, source file |
| `docs/master-data/items.md` | id, name, type |
| `docs/master-data/skills.md` | id, owner (character or monster), name |
| `docs/master-data/quests.md` | id, name, map |

Also write:

- `docs/index.md` — path, format, row count, section
- `docs/endpoints.md` — from `catalog-endpoints.sh`
- `docs/boot-sequence.md` — ordered calls; see [server-deduction-checklist.md](server-deduction-checklist.md)

## Unity extras

See [unity-il2cpp.md](unity-il2cpp.md).

- Il2CppDumper: `dump.cs`, `script.json`, `stringliteral.json`, DummyDll
- Addressables: `catalog.json` / `catalog.bin` slugs for scenes and tables
- Packed metadata: dump `global-metadata.dat` from memory after `MetadataCache.Initialize`, then re-run Il2CppDumper on the raw bytes

## Search names

`catalog-client.sh` matches path basenames containing:

`monster`, `enemy`, `npc`, `hero`, `character`, `role`, `map`, `scene`, `stage`, `dungeon`, `activity`, `event`, `item`, `equip`, `skill`, `spell`, `quest`, `mission`, `drop`, `reward`

Add paths the script missed to `docs/index.md` by hand. A basename in another language still counts if `dump.cs` shows it is a table.

## Server use

Copy stable IDs into the case SQLite database as read-only master tables. Account and character rows stay writable. See [data-model.md](data-model.md).

Do not commit the APK, AssetBundles, or full table dumps into this skill repo. They stay in the case directory.
