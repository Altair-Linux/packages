#!/bin/sh
# linux-headers/build.sh
# Installs sanitised Linux API headers into $DESTDIR.
# These headers are consumed by musl/glibc and any userspace code that
# includes <linux/...> or <asm/...>.  No compilation takes place here;
# "headers_install" is a pure copy/filter step performed by the kernel's
# own Makefile.
#
# Prerequisites: make, perl (for the kernel's unifdef script).
# Architecture is inferred from the host unless ARCH is set externally.
set -eu

: "${ARCH:=x86_64}"
: "${DESTDIR:?DESTDIR must be set}"

# Abort if the package manager somehow passed an unverified source.
case "${SOURCE_SHA256:-unset}" in
  placeholder-*|unset)
    echo "error: SOURCE_SHA256 is not set or is a placeholder. Refusing to build." >&2
    exit 1
    ;;
esac

# The kernel's headers_install target requires an absolute path.
HDRDIR="$(realpath "${DESTDIR}/usr")"

make ARCH="${ARCH}" \
     INSTALL_HDR_PATH="${HDRDIR}" \
     headers_install

# Remove files that leak internal kernel types not meant for userspace.
find "${HDRDIR}/include" \
     \( -name '.install' -o -name '..install.cmd' \) \
     -delete
