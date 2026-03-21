#!/bin/sh
set -eu
: "${DESTDIR:?DESTDIR must be set}"
: "${PREFIX:=/usr}"
case "${SOURCE_SHA256:-unset}" in
  placeholder-*|unset)
    echo "error: SOURCE_SHA256 is not set or is a placeholder. Refusing to build." >&2
    exit 1 ;;
esac
make -j"${JOBS:-$(nproc)}" \
    CC="${CC:-gcc}" \
    PREFIX="${PREFIX}" \
    DESTDIR="${DESTDIR}" \
    SBINDIR="${PREFIX}/sbin" \
    CONFDIR="${PREFIX}/etc/iproute2" \
    DOCDIR="${PREFIX}/share/doc/iproute2" \
    MANDIR="${PREFIX}/share/man" \
    DBM_INCLUDE= \
    install
