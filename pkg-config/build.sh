#!/bin/sh
# pkg-config/build.sh
# Builds pkg-config with an internal copy of glib (--with-internal-glib)
# so it has no external dependencies and is safe to build early in the
# bootstrap chain before any libraries are installed.
#
# Prerequisites: musl, gcc, make.
set -eu

: "${DESTDIR:?DESTDIR must be set}"
: "${PREFIX:=/usr}"

case "${SOURCE_SHA256:-unset}" in
  placeholder-*|unset)
    echo "error: SOURCE_SHA256 is not set or is a placeholder. Refusing to build." >&2
    exit 1
    ;;
esac

./configure \
    --prefix="${PREFIX}" \
    --with-internal-glib \
    --disable-host-tool \
    --docdir="${PREFIX}/share/doc/pkg-config"

make -j"${JOBS:-$(nproc)}"
make DESTDIR="${DESTDIR}" install
