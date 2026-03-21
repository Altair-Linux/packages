#!/bin/sh
# common.sh — sourced by all Altair Linux build scripts.
# Do not execute directly.

# Abort if SOURCE_SHA256 is unset or still a placeholder.
check_sha256() {
    case "${SOURCE_SHA256:-unset}" in
        placeholder-*|unset)
            echo "error: SOURCE_SHA256 is not set or is a placeholder. Refusing to build." >&2
            exit 1
            ;;
    esac
}

# Abort if DESTDIR is not set.
check_destdir() {
    : "${DESTDIR:?DESTDIR must be set}"
}

# Run both checks — call this at the top of every build.sh.
astra_build_init() {
    check_destdir
    check_sha256
}
