#!/bin/sh
# sed/build.sh
# Builds GNU sed.
# sed is used heavily by autoconf-generated configure scripts and by
# many build systems throughout the bootstrap chain.
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
    --disable-nls \
    --disable-i18n

make -j"${JOBS:-$(nproc)}"
make DESTDIR="${DESTDIR}" install
