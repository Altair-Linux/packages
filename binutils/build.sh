#!/bin/sh
# binutils/build.sh
# Builds GNU binutils (as, ld, ar, nm, objcopy, objdump, strip, etc.).
# binutils must be present before gcc, as gcc's build system invokes
# the assembler and linker directly.
#
# Prerequisites: musl, linux-headers, a working host C compiler.
# Build is done out-of-tree as required by the binutils build system.
set -eu

: "${PREFIX:=/usr}"

. "$(dirname "$0")/../common.sh"
astra_build_init

mkdir -p build
cd build

../configure \
    --prefix="${PREFIX}" \
    --target="${ALTAIR_TARGET}" \
    --host="${ALTAIR_TARGET}" \
    --build="${ALTAIR_TARGET}" \
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
