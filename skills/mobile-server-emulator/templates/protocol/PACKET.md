# Protocol note PKT-___

- ID:
- version triple:
- direction: C→S | S→C
- transport:
- previous message:
- encoding: JSON | Protobuf | custom frame | undecoded
- evidence: `capture/samples/...`

## Observation

```text
length:
first 16 bytes:
header length (or unknown):
fields or JSON:
```

## Client behavior

- on success:
- on failure (one logcat line):

## Implementation

- handler:
- result: pending | ok | protocol_error | unimplemented
- verification:
