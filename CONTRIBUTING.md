# Contributing

## Recipe requirements

Each package recipe directory must include:

- `astra.pkg` metadata
- `build.sh` build instructions
- `files/` payload tree

## Validation checklist

1. Build package with `astra build`.
2. Ensure no compiled artifacts are committed.
3. Confirm metadata fields are complete and valid.
4. Keep changes scoped to package recipes only.
