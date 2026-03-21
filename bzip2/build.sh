#!/bin/sh
set -eu
: "${DESTDIR:?DESTDIR must be set}"
: "${PREFIX:=/usr}"
case "${SOURCE_SHA256:-unset}" in
  placeholder-*|unset)
    echo "error: SOURCE_SHA256 is not set or is a placeholder. Refusing to build." >&2
    exit 1 ;;
esac
make -f Makefile-libbz2_so CC="${CC:-gcc}" CFLAGS="${CFLAGS:--O2}"
make -j"${JOBS:-$(nproc)}" CC="${CC:-gcc}" CFLAGS="${CFLAGS:--O2}"
make PREFIX="${DESTDIR}${PREFIX}" install
cp libbz2.so.1.0.8 "${DESTDIR}${PREFIX}/lib/"
ln -sf libbz2.so.1.0.8 "${DESTDIR}${PREFIX}/lib/libbz2.so.1.0"
ln -sf libbz2.so.1.0 "${DESTDIR}${PREFIX}/lib/libbz2.so"
ln -sf bzip2 "${DESTDIR}${PREFIX}/bin/bunzip2"
ln -sf bzip2 "${DESTDIR}${PREFIX}/bin/bzcat"
