#!/bin/sh
# astra/build.sh
# Builds the Astra package manager for Altair Linux.
#
# Astra is the final package in the bootstrap chain. By the time this
# script runs, the following must already be installed:
#   musl, gcc, make, openssl, zlib, ca-certificates, curl
#
# Astra is a Rust project. Cargo and the Rust toolchain must be available.
set -eu

. "$(dirname "$0")/../common.sh"
astra_build_init

: "${PREFIX:=/usr}"

# Capture working directory before any cd for stable path references.
BUILD_DIR="$(pwd)/target"

# Prefer the top-level Cargo.toml at depth 1 — this is unambiguous even
# in workspace layouts where member crates add their own Cargo.toml files
# at depth 2+. Only fall back to depth 2 if nothing exists at depth 1.
SRC_ROOT=$(find . -mindepth 1 -maxdepth 1 -name 'Cargo.toml' | head -n1 | xargs -r dirname)

if [ -z "${SRC_ROOT}" ]; then
    # Depth-2 fallback: take the shallowest candidate, excluding
    # target/, examples/, and tests/ to avoid workspace member noise.
    SRC_ROOT=$(
        find . \
            \( -path '*/target/*' -o -path '*/examples/*' -o -path '*/tests/*' \) -prune \
            -o -mindepth 2 -maxdepth 2 -name 'Cargo.toml' -print \
        | sort | head -n1 | xargs -r dirname
    )
fi

if [ -z "${SRC_ROOT}" ]; then
    echo "error: could not locate Cargo.toml in unpacked source tree." >&2
    exit 1
fi

cd "${SRC_ROOT}"

cargo build --release --target-dir "${BUILD_DIR}" -p astra

install -Dm755 "${BUILD_DIR}/release/astra" "${DESTDIR}${PREFIX}/bin/astra"

"${DESTDIR}${PREFIX}/bin/astra" --version
