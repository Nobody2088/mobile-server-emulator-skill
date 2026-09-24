# Boot sequence

Order the client actually uses. A later step that runs before an earlier success is a missing handler. Same order as the skill file `references/account-flow.md`.

| Step | Call | Host role | Must succeed before | Evidence |
|------|------|-----------|---------------------|----------|
| 1 | version / update | update | register or login | |
| 2 | register or guest create | login | login token | |
| 3 | login | login | server list | |
| 4 | server list | login | character list | |
| 5 | character list | login | create character or enter game | |
| 6 | create character | login | enter game | |
| 7 | enter game | login | gateway auth | |
| 8 | gateway auth | gateway | player blob | |
| 9 | enter map | game | gameplay messages | |

## Notes

- Login token vs gate token:
- Gateway host in the enter-game response (LAN IP or domain):
- Hardcoded ports:
- Tables shipped in the APK or downloaded:
