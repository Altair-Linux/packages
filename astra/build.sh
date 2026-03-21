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
# The package manager is expected to unpack the Astra source tarball into
# a subdirectory named after the archive stem, e.g.:
#   Astra-rolling-<sha>/
# ASTRA_PKG_VERSION is set by the package manager from Astrafile.yaml.
set -eu

. "$(dirname "$0")/../common.sh"
astra_build_init

: "${PREFIX:=/usr}"
: "${ASTRA_PKG_VERSION:=rolling-6d886735d7633cfad497988f854e2b9f70d08b9f}"

# Capture working directory before cd for stable path references.
BUILD_DIR="$(pwd)/target"

# The GitHub archive for tag T unpacks as "Astra-T/".
# Derive the source root from the known tarball layout rather than
# using heuristic find logic that could pick the wrong directory.
SRC_ROOT="Astra-${ASTRA_PKG_VERSION}"

if [ ! -f "${SRC_ROOT}/Cargo.toml" ]; then
    echo "error: expected source root '${SRC_ROOT}' not found or missing Cargo.toml." >&2
    echo "       Set ASTRA_PKG_VERSION to match the unpacked directory name." >&2
    exit 1
fi

cd "${SRC_ROOT}"

cargo build --release --target-dir "${BUILD_DIR}" -p astra

install -Dm755 "${BUILD_DIR}/release/astra" "${DESTDIR}${PREFIX}/bin/astra"

"${DESTDIR}${PREFIX}/bin/astra" --version
