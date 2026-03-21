#!/bin/sh
# gcc/build.sh
# Builds GCC with C and C++ support against musl libc.
#
# Bootstrap note: GCC requires itself to build. On the very first pass
# a host GCC (or a cross-compiler) is used. Once binutils and musl are
# installed, this script produces the Altair-native compiler.
#
# GCC requires bundled prerequisites. Fetch them before running:
#   cd gcc-13.3.0 && ./contrib/download_prerequisites
# This pulls in gmp, mpfr, mpc, and isl built in-tree.
#
# Prerequisites: musl, linux-headers, binutils, make.
# Build must be done out-of-tree.
set -eu

: "${DESTDIR:?DESTDIR must be set}"
: "${PREFIX:=/usr}"

case "${SOURCE_SHA256:-unset}" in
  placeholder-*|unset)
    echo "error: SOURCE_SHA256 is not set or is a placeholder. Refusing to build." >&2
    exit 1
    ;;
esac

if [ ! -d gmp ]; then
    ./contrib/download_prerequisites
fi

mkdir -p build
cd build

../configure \
    --prefix="${PREFIX}" \
    --target=x86_64-altair-linux-musl \
    --host=x86_64-altair-linux-musl \
    --build=x86_64-altair-linux-musl \
    --enable-languages=c,c++ \
    --with-sysroot=/ \
    --enable-shared \
    --enable-static \
    --enable-threads=posix \
    --enable-__cxa_atexit \
    --disable-multilib \
    --disable-nls \
    --disable-bootstrap \
    --disable-libsanitizer \
    --disable-libquadmath \
    --disable-libgomp \
    --with-system-zlib \
    --with-linker-hash-style=gnu \
    --with-arch=x86-64 \
    --with-tune=generic

make -j"${JOBS:-$(nproc)}"
make DESTDIR="${DESTDIR}" install

ln -sf gcc "${DESTDIR}${PREFIX}/bin/cc"
