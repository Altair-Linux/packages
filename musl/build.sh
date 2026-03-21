#!/bin/sh
# musl/build.sh
# Builds and installs the musl C library.
# musl is the system libc for Altair Linux; it must be built before
# binutils or gcc, which link against it.
#
# Prerequisites: a working host C compiler, linux-headers installed.
# On the very first bootstrap pass a host gcc is used; subsequent passes
# use the previously installed musl-gcc wrapper.
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
    --syslibdir="/lib" \
    --enable-static \
    --enable-shared

make -j"${JOBS:-$(nproc)}"
make DESTDIR="${DESTDIR}" install

# Create the musl-gcc wrapper symlink expected by downstream build scripts.
if [ -f "${DESTDIR}${PREFIX}/bin/musl-gcc" ]; then
    ln -sf musl-gcc "${DESTDIR}${PREFIX}/bin/musl-cc"
fi
