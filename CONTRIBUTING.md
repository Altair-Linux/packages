# Contributing

## Recipe requirements

Each package recipe directory must include:

- `astra.pkg` metadata
- `Astrafile.yaml` metadata
- `build.sh` build instructions
- `files/` payload tree

Package directories should follow the structure:

```
<package>/
	astra.pkg
	Astrafile.yaml
	build.sh
	files/
		usr/
			bin/
				<binary>
```

Current sample recipes include `nano`, `curl`, `htop`, `jq`, `ripgrep`, and `tree`.

## Validation checklist

1. Build package with `astra build`.
2. Ensure no compiled artifacts are committed.
3. Confirm metadata fields are complete and valid.
4. Keep changes scoped to package recipes only.

Recommended local verification loop:

```bash
astra init --data-dir .astra-ci --root .astra-root
astra key generate --data-dir .astra-ci --root .astra-root

for pkg in nano curl htop jq ripgrep tree; do
	astra build "$pkg" --output ../tmp/out --data-dir .astra-ci --root .astra-root
done
```

Each recipe should produce one artifact named `<name>-<version>-<arch>.astpkg`.
