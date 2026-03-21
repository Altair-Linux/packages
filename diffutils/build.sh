#!/bin/sh
# diffutils/build.sh
# Builds GNU diffutils (diff, cmp, diff3, sdiff).
# Required by the bootstrap chain — patch depends on diff to generate
# and verify hunks, and many build systems call diff directly.
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
