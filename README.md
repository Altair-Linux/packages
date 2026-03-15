# Altair Linux Packages

This repository contains package recipes and build definitions for Altair Linux.

## Repository layout

- `nano/`, `curl/`, `htop/`, `jq/`, `ripgrep/`, `tree/` sample package recipes.
- `*/astra.pkg` metadata file consumed by `astra build`.
- `*/Astrafile.yaml` metadata file consumed by modern Astra builders.
- `*/build.sh` package build script.
- `*/files/` filesystem layout copied into package payload.

## Included sample packages

- `nano` 7.2.0
- `curl` 8.7.1
- `htop` 3.3.0
- `jq` 1.7.1
- `ripgrep` 14.1.0
- `tree` 2.1.1

## Build example

From the `Astra` repository root:

```bash
./target/debug/astra build ../packages/nano --output ../altair-repo/unstable/packages
```

Build all sample recipes sequentially into a standard output directory:

```bash
mkdir -p ../tmp/out
for pkg in nano curl htop jq ripgrep tree; do
	./target/debug/astra build "../packages/${pkg}" --output ../tmp/out
done
```

## CI/CD behavior

- Package recipes are auto-discovered from directories containing `astra.pkg`.
- Builds run sequentially for repeatable outputs and race-free publishing.
- Standardized build artifacts are exported in `dist/standard-output/*.astpkg`.
- Successful main-branch builds can open an automated PR in `altair-repo` that:
	- publishes built artifacts to `unstable/packages/`
	- regenerates `unstable/index.json`

This repository must not contain compiled `.astpkg` artifacts.
