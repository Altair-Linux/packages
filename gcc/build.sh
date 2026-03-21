#!/bin/sh
# gcc/build.sh
# Builds GCC with C and C++ support against musl libc.
#
# Bootstrap note: GCC requires itself to build. On the very first pass
# a host GCC (or a cross-compiler) is used. Once binutils and musl are
# installed, this script produces the Altair-native compiler.
#
# GCC prerequisite libraries (gmp, mpfr, mpc, isl) must be vendored
# alongside this source tree before building. They are declared as
# additional sources in Astrafile.yaml and extracted by the package
# manager into the gcc source directory before this script runs.
#
# Prerequisites: musl, linux-headers, binutils, make.
# Build must be done out-of-tree.
set -eu

. "$(dirname "$0")/../common.sh"
astra_build_init

: "${PREFIX:=/usr}"

# ALTAIR_TARGET: the target triple we are building FOR.
# ALTAIR_BUILD:  the triple of the machine running this build (defaults to target for native builds).
# ALTAIR_HOST:   the triple of the machine that will run the compiler (defaults to target).
: "${ALTAIR_BUILD:=${ALTAIR_TARGET}}"
: "${ALTAIR_HOST:=${ALTAIR_TARGET}}"

# Derive arch-specific GCC flags from ALTAIR_TARGET so non-x86_64
# targets are configured correctly.
case "${ALTAIR_TARGET}" in
    x86_64-*)
        ARCH_FLAGS="--with-arch=x86-64 --with-tune=generic"
        ;;
    aarch64-*)
        ARCH_FLAGS="--with-arch=armv8-a"
        ;;
    riscv64-*)
        ARCH_FLAGS="--with-arch=rv64gc --with-abi=lp64d"
        ;;
    armv7-*)
        ARCH_FLAGS="--with-arch=armv7-a --with-float=hard --with-fpu=vfpv3-d16"
        ;;
    *)
        ARCH_FLAGS=""
        ;;
esac

mkdir -p build
cd build

# shellcheck disable=SC2086
../configure \
    --prefix="${PREFIX}" \
    --target="${ALTAIR_TARGET}" \
    --host="${ALTAIR_HOST}" \
    --build="${ALTAIR_BUILD}" \
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
    ${ARCH_FLAGS}

make -j"${JOBS:-$(nproc)}"
make DESTDIR="${DESTDIR}" install

ln -sf gcc "${DESTDIR}${PREFIX}/bin/cc"
