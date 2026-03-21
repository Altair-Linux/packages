#!/bin/sh
set -eu
: "${DESTDIR:?DESTDIR must be set}"
: "${PREFIX:=/usr}"
case "${SOURCE_SHA256:-unset}" in
  placeholder-*|unset)
    echo "error: SOURCE_SHA256 is not set or is a placeholder. Refusing to build." >&2
    exit 1 ;;
esac
./configure \
    --prefix="${PREFIX}" \
    --disable-nls \
    --localstatedir=/var/lib/locate
make -j"${JOBS:-$(nproc)}"
make DESTDIR="${DESTDIR}" install
