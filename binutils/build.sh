#!/bin/sh
# binutils/build.sh
# Builds GNU binutils (as, ld, ar, nm, objcopy, objdump, strip, etc.).
# binutils must be present before gcc, as gcc's build system invokes
# the assembler and linker directly.
#
# Prerequisites: musl, linux-headers, a working host C compiler.
# Build is done out-of-tree as required by the binutils build system.
set -eu

. "$(dirname "$0")/../common.sh"
astra_build_init

: "${PREFIX:=/usr}"

# ALTAIR_BUILD and ALTAIR_HOST default to ALTAIR_TARGET (set in common.sh) for native builds.

mkdir -p build
cd build

../configure \
    --prefix="${PREFIX}" \
    --target="${ALTAIR_TARGET}" \
    --host="${ALTAIR_HOST}" \
    --build="${ALTAIR_BUILD}" \
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
