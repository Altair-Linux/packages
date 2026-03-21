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

# Capture the working directory before any cd so we have a stable
# reference for --target-dir and install, without relying on OLDPWD.
BUILD_DIR="$(pwd)/target"

# Locate the top-level Cargo.toml. The package manager unpacks the source
# archive into a single subdirectory. We search at depth 1 and 2, explicitly
# pruning target/, examples/, and tests/ to avoid false matches from
# workspace members. We require exactly one candidate.
CANDIDATES=$(
    find . \
        \( -path '*/target/*' -o -path '*/examples/*' -o -path '*/tests/*' \) -prune \
        -o -mindepth 1 -maxdepth 2 -name 'Cargo.toml' -print \
    | sort
)

COUNT=$(printf '%s\n' "${CANDIDATES}" | grep -c . || true)

if [ "${COUNT}" -eq 0 ]; then
    echo "error: no Cargo.toml found in unpacked source tree." >&2
    exit 1
elif [ "${COUNT}" -gt 1 ]; then
    echo "error: multiple Cargo.toml candidates found — cannot determine source root:" >&2
    printf '%s\n' "${CANDIDATES}" >&2
    exit 1
fi

SRC_ROOT=$(dirname "${CANDIDATES}")
cd "${SRC_ROOT}"

cargo build --release --target-dir "${BUILD_DIR}" -p astra

install -Dm755 "${BUILD_DIR}/release/astra" "${DESTDIR}${PREFIX}/bin/astra"

"${DESTDIR}${PREFIX}/bin/astra" --version
