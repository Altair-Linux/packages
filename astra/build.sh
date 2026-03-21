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
# The package manager unpacks the Astra source tarball into a directory
# named after the archive stem: Astra-<version>/
# ASTRA_PKG_VERSION is set by the package manager from Astrafile.yaml,
# so bumping the version there automatically keeps this script correct.
set -eu

. "$(dirname "$0")/../common.sh"
astra_build_init

: "${PREFIX:=/usr}"

# ASTRA_PKG_VERSION is injected by the package manager from Astrafile.yaml.
# We do not hard-code a fallback here — if it is unset the build fails
# explicitly rather than silently using a stale version string.
if [ -z "${ASTRA_PKG_VERSION:-}" ]; then
    echo "error: ASTRA_PKG_VERSION is not set. The package manager must inject this from Astrafile.yaml." >&2
    exit 1
fi

# Capture working directory before cd for stable path references.
BUILD_DIR="$(pwd)/target"

# GitHub archives unpack as "<repo>-<tag>/", so the source root is deterministic.
SRC_ROOT="Astra-${ASTRA_PKG_VERSION}"

if [ ! -f "${SRC_ROOT}/Cargo.toml" ]; then
    echo "error: expected source root '${SRC_ROOT}' not found or missing Cargo.toml." >&2
    exit 1
fi

cd "${SRC_ROOT}"

cargo build --release --target-dir "${BUILD_DIR}" -p astra

install -Dm755 "${BUILD_DIR}/release/astra" "${DESTDIR}${PREFIX}/bin/astra"

"${DESTDIR}${PREFIX}/bin/astra" --version
