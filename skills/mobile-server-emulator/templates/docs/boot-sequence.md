# Boot sequence

Order the client actually uses. A later step that runs before an earlier success is a missing handler.

| Step | Call | Host role | Must succeed before | Evidence |
|------|------|-----------|---------------------|----------|
| 1 | version / update | update | gateway | |
| 2 | gateway | gateway | login | |
| 3 | login | login | character list | |
| 4 | character list | game or login | enter map | |
| 5 | enter map | game | gameplay messages | |

## Notes

- Hardcoded ports:
- Tables shipped in the APK or downloaded:
