#!/bin/sh
# openssl/build.sh
# Builds OpenSSL TLS/SSL and cryptography library.
# Required by curl, wget, openssh, and ca-certificates.
# OpenSSL uses its own perl-based Configure script, not autoconf.
#
# Prerequisites: musl, gcc, make, zlib, perl.
set -eu

: "${DESTDIR:?DESTDIR must be set}"
: "${PREFIX:=/usr}"

case "${SOURCE_SHA256:-unset}" in
  placeholder-*|unset)
    echo "error: SOURCE_SHA256 is not set or is a placeholder. Refusing to build." >&2
    exit 1
    ;;
esac

perl Configure \
    linux-x86_64 \
    --prefix="${PREFIX}" \
    --openssldir="/etc/ssl" \
    --libdir=lib \
    shared \
    zlib \
    no-tests \
    no-docs

make -j"${JOBS:-$(nproc)}"
make DESTDIR="${DESTDIR}" install_sw install_ssldirs
