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

# The package manager unpacks the source archive into a subdirectory.
# Locate the Cargo.toml to find the actual source root robustly rather
# than assuming a fixed directory name based on the archive.
SRC_ROOT=$(find . -maxdepth 2 -name 'Cargo.toml' -not -path '*/target/*' | head -n1 | xargs dirname)
cd "${SRC_ROOT}"

cargo build --release --target-dir "${OLDPWD}/target" -p astra

install -Dm755 "${OLDPWD}/target/release/astra" "${DESTDIR}${PREFIX}/bin/astra"

"${DESTDIR}${PREFIX}/bin/astra" --version
