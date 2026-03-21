#!/bin/sh
# make/build.sh
# Builds GNU Make.
# make is needed by virtually every subsequent package build; it must
# be available before any autoconf/automake-based package is compiled.
#
# Prerequisites: musl, gcc.
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
    --without-guile \
    --disable-nls

make -j"${JOBS:-$(nproc)}"
make DESTDIR="${DESTDIR}" install
