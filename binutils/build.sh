#!/bin/sh
# binutils/build.sh
# Builds GNU binutils (as, ld, ar, nm, objcopy, objdump, strip, etc.).
# binutils must be present before gcc, as gcc's build system invokes
# the assembler and linker directly.
#
# Prerequisites: musl, linux-headers, a working host C compiler.
# Build is done out-of-tree as required by the binutils build system.
set -eu

: "${DESTDIR:?DESTDIR must be set}"
: "${PREFIX:=/usr}"

case "${SOURCE_SHA256:-unset}" in
  placeholder-*|unset)
    echo "error: SOURCE_SHA256 is not set or is a placeholder. Refusing to build." >&2
    exit 1
    ;;
esac

mkdir -p build
cd build

../configure \
    --prefix="${PREFIX}" \
    --target=x86_64-altair-linux-musl \
    --host=x86_64-altair-linux-musl \
    --build=x86_64-altair-linux-musl \
    --with-sysroot=/ \
    --enable-shared \
    --enable-static \
    --enable-gold \
    --enable-plugins \
    --enable-deterministic-archives \
    --disable-multilib \
    --disable-nls \
    --disable-werror

make -j"${JOBS:-$(nproc)}"
make DESTDIR="${DESTDIR}" install

find "${DESTDIR}${PREFIX}/lib" -name '*.a' -delete
