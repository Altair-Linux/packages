#!/bin/sh
# openssl/build.sh
# Builds OpenSSL TLS/SSL and cryptography library.
# Required by curl, wget, openssh, and ca-certificates.
# OpenSSL uses its own perl-based Configure script, not autoconf.
#
# Prerequisites: musl, gcc, make, zlib, perl.
set -eu

. "$(dirname "$0")/../common.sh"
astra_build_init

: "${PREFIX:=/usr}"

# Map ALTAIR_TARGET to the OpenSSL platform string.
# Default to linux-x86_64 if unset or unrecognized.
case "${ALTAIR_TARGET:-x86_64-altair-linux-musl}" in
    x86_64-*)  OPENSSL_PLATFORM="linux-x86_64" ;;
    aarch64-*) OPENSSL_PLATFORM="linux-aarch64" ;;
    armv7-*)   OPENSSL_PLATFORM="linux-armv4" ;;
    riscv64-*) OPENSSL_PLATFORM="linux64-riscv64" ;;
    *)
        echo "warning: unknown ALTAIR_TARGET '${ALTAIR_TARGET}', defaulting to linux-x86_64" >&2
        OPENSSL_PLATFORM="linux-x86_64"
        ;;
esac

perl Configure \
    "${OPENSSL_PLATFORM}" \
    --prefix="${PREFIX}" \
    --openssldir="/etc/ssl" \
    --libdir=lib \
    shared \
    zlib \
    no-tests \
    no-docs

make -j"${JOBS:-$(nproc)}"
make DESTDIR="${DESTDIR}" install_sw install_ssldirs
