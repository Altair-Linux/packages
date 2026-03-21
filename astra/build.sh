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

# Locate the top-level Cargo.toml. The package manager unpacks the source
# archive into a single subdirectory; we expect exactly one candidate at
# depth 1 or 2, excluding workspace members, examples, and tests.
# Fail explicitly if zero or more than one candidate is found.
CANDIDATES=$(find . \( -path '*/target/*' -o -path '*/examples/*' -o -path '*/tests/*' \) -prune \
    -o -mindepth 1 -maxdepth 2 -name 'Cargo.toml' -print \
    | sort)

COUNT=$(echo "${CANDIDATES}" | grep -c 'Cargo.toml' || true)

if [ "${COUNT}" -eq 0 ]; then
    echo "error: no Cargo.toml found in unpacked source tree." >&2
    exit 1
elif [ "${COUNT}" -gt 1 ]; then
    echo "error: multiple Cargo.toml candidates found — cannot determine source root:" >&2
    echo "${CANDIDATES}" >&2
    exit 1
fi

SRC_ROOT=$(dirname "${CANDIDATES}")
cd "${SRC_ROOT}"

cargo build --release --target-dir "${OLDPWD}/target" -p astra

install -Dm755 "${OLDPWD}/target/release/astra" "${DESTDIR}${PREFIX}/bin/astra"

"${DESTDIR}${PREFIX}/bin/astra" --version
