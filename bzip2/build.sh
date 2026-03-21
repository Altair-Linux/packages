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

# The bzip2 shared library uses an upstream-stable SONAME of libbz2.so.1.0
# regardless of the patch version. ASTRA_PKG_VERSION identifies the full
# package version (e.g. 1.0.8) for the physical file name, while the
# SONAME stays fixed at 1.0 to preserve ABI compatibility across patch bumps.
if [ -z "${ASTRA_PKG_VERSION:-}" ]; then
    echo "error: ASTRA_PKG_VERSION is not set. The package manager must inject this from Astrafile.yaml." >&2
    exit 1
fi
LIBBZ2_SONAME="libbz2.so.1.0"
LIBBZ2_SO="libbz2.so.${ASTRA_PKG_VERSION}"

# Build shared library.
make -f Makefile-libbz2_so CC="${CC:-gcc}" CFLAGS="${CFLAGS:--O2}"

# Build static tools.
make -j"${JOBS:-$(nproc)}" CC="${CC:-gcc}" CFLAGS="${CFLAGS:--O2}"

make PREFIX="${DESTDIR}${PREFIX}" install

# Install shared library with correct SONAME chain.
cp "${LIBBZ2_SO}" "${DESTDIR}${PREFIX}/lib/"
ln -sf "${LIBBZ2_SO}" "${DESTDIR}${PREFIX}/lib/${LIBBZ2_SONAME}"
ln -sf "${LIBBZ2_SONAME}" "${DESTDIR}${PREFIX}/lib/libbz2.so"

# Convenience symlinks.
ln -sf bzip2 "${DESTDIR}${PREFIX}/bin/bunzip2"
ln -sf bzip2 "${DESTDIR}${PREFIX}/bin/bzcat"
