#!/bin/sh
# astra/build.sh
# Builds the Astra package manager for Altair Linux.
#
# Astra is the final package in the bootstrap chain. By the time this
# script runs, the following must already be installed:
#   musl, gcc, make, openssl, zlib, ca-certificates, curl
#
# Astra is a Rust project. Cargo and the Rust toolchain must be available.
#
# The package manager is expected to unpack the source archive into a
# directory matching the archive stem. We constrain the Cargo.toml search
# to depth 1 only (the immediate subdirectory) to avoid ambiguity if
# workspace members or example crates add their own Cargo.toml files.
set -eu

. "$(dirname "$0")/../common.sh"
astra_build_init

: "${PREFIX:=/usr}"

# Locate the top-level Cargo.toml at exactly depth 1 — the unpacked
# source root. Fail explicitly if not found rather than silently using
# a wrong directory.
SRC_ROOT=$(find . -mindepth 1 -maxdepth 1 -name 'Cargo.toml' | head -n1 | xargs -r dirname)
if [ -z "${SRC_ROOT}" ]; then
    # Try depth 2 as fallback for archives that add one wrapper directory.
    SRC_ROOT=$(find . -mindepth 2 -maxdepth 2 -name 'Cargo.toml' -not -path '*/target/*' \
        | grep -v '/examples/' | grep -v '/tests/' | head -n1 | xargs -r dirname)
fi
if [ -z "${SRC_ROOT}" ]; then
    echo "error: could not locate Cargo.toml in unpacked source tree." >&2
    exit 1
fi

cd "${SRC_ROOT}"

cargo build --release --target-dir "${OLDPWD}/target" -p astra

install -Dm755 "${OLDPWD}/target/release/astra" "${DESTDIR}${PREFIX}/bin/astra"

"${DESTDIR}${PREFIX}/bin/astra" --version
