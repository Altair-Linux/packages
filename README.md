# Altair Linux Packages

This repository contains package recipes and build definitions for Altair Linux. It provides the full bootstrap chain required to build a self-hosting Altair Linux system from scratch.

## Repository layout

- `*/astra.pkg` — flat metadata file consumed by `astra build`
- `*/Astrafile.yaml` — full metadata including source URL and SHA256
- `*/build.sh` — package build script
- `*/files/` — filesystem payload stub copied into the package

## Bootstrap chain

Packages are ordered by dependency. The full bootstrap sequence is:

| # | Package | Version |
|---|---------|---------|
| 1 | linux-headers | 6.9.12 |
| 2 | musl | 1.2.5 |
| 3 | binutils | 2.42 |
| 4 | gcc | 13.3.0 |
| 5 | make | 4.4.1 |
| 6 | pkg-config | 0.29.2 |
| 7 | patch | 2.7.6 |
| 8 | diffutils | 3.10 |
| 9 | sed | 4.9 |
| 10 | grep | 3.11 |
| 11 | coreutils | 9.5 |
| 12 | findutils | 4.10.0 |
| 13 | gawk | 5.3.0 |
| 14 | tar | 1.35 |
| 15 | gzip | 1.13 |
| 16 | xz | 5.6.2 |
| 17 | bzip2 | 1.0.8 |
| 18 | ncurses | 6.5 |
| 19 | readline | 8.2 |
| 20 | bash | 5.2.21 |
| 21 | util-linux | 2.40.1 |
| 22 | zlib | 1.3.1 |
| 23 | openssl | 3.3.1 |
| 24 | ca-certificates | 20240203 |
| 25 | wget | 1.21.4 |
| 26 | iproute2 | 6.9.0 |
| 27 | openssh | 9.8p1 |
| 28 | e2fsprogs | 1.47.1 |
| 29 | shadow | 4.16.0 |
| 30 | astra | rolling |

Additional packages included: `nano`, `curl`, `htop`, `jq`, `ripgrep`, `tree`.

## Building locally

Install and initialise Astra, then build any package:

```bash
astra init --data-dir .astra-ci --root .astra-root
astra key generate --data-dir .astra-ci --root .astra-root
astra build nano --output ../tmp/out --data-dir .astra-ci --root .astra-root
```

Build the full bootstrap chain sequentially:

```bash
astra init --data-dir .astra-ci --root .astra-root
astra key generate --data-dir .astra-ci --root .astra-root

for pkg in linux-headers musl binutils gcc make pkg-config patch diffutils \
           sed grep coreutils findutils gawk tar gzip xz bzip2 ncurses \
           readline bash util-linux zlib openssl ca-certificates wget \
           iproute2 openssh e2fsprogs shadow astra; do
    astra build "$pkg" --output ../tmp/out --data-dir .astra-ci --root .astra-root
done
```

## CI/CD

On every push and pull request:

- All package recipes are auto-discovered from directories containing `astra.pkg`
- Each package is built and integration-tested (install → remove → upgrade)
- Built `.astpkg` artifacts are uploaded and available for download from the Actions run

On push to `main`:

- All artifacts are collected into a single `astra-packages` artifact
- Packages are published to the `unstable` channel in `altair-repo`

This repository must not contain compiled `.astpkg` artifacts.
