#!/bin/sh
# bzip2/build.sh
# Builds bzip2 and libbz2.
# bzip2 does not use autoconf; it ships a plain Makefile.
#
# Prerequisites: musl, gcc, make.
set -eu

. "$(dirname "$0")/../common.sh"
astra_build_init

: "${PREFIX:=/usr}"

# Derive the versioned library name from ASTRA_PKG_VERSION, which the
# package manager sets from Astrafile.yaml at build time. This ensures
# the library filename stays in sync with the declared package version
# without hard-coding it here. Falls back to the current known version.
: "${ASTRA_PKG_VERSION:=1.0.8}"
LIBBZ2_SO="libbz2.so.${ASTRA_PKG_VERSION}"

# Build shared library.
make -f Makefile-libbz2_so CC="${CC:-gcc}" CFLAGS="${CFLAGS:--O2}"

# Build static tools.
make -j"${JOBS:-$(nproc)}" CC="${CC:-gcc}" CFLAGS="${CFLAGS:--O2}"

make PREFIX="${DESTDIR}${PREFIX}" install

# Install shared library.
cp "${LIBBZ2_SO}" "${DESTDIR}${PREFIX}/lib/"
ln -sf "${LIBBZ2_SO}" "${DESTDIR}${PREFIX}/lib/libbz2.so.1.0"
ln -sf libbz2.so.1.0 "${DESTDIR}${PREFIX}/lib/libbz2.so"

# Convenience symlinks.
ln -sf bzip2 "${DESTDIR}${PREFIX}/bin/bunzip2"
ln -sf bzip2 "${DESTDIR}${PREFIX}/bin/bzcat"
