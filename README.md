# Altair Linux Packages

This repository contains package recipes and build definitions for Altair Linux.

## Repository layout

- `nano/` example package recipe.
- `*/astra.pkg` metadata file consumed by `astra build`.
- `*/build.sh` package build script.
- `*/files/` filesystem layout copied into package payload.

## Build example

From the `Astra` repository root:

```bash
./target/debug/astra build ../packages/nano --output ../altair-repo/unstable/packages
```

This repository must not contain compiled `.astpkg` artifacts.
