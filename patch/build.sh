#!/bin/sh
# patch/build.sh
# Builds GNU patch.
# patch is required early in the bootstrap chain — many upstream packages
# ship patches that must be applied before building.
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
    --disable-nls

make -j"${JOBS:-$(nproc)}"
make DESTDIR="${DESTDIR}" install
