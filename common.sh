#!/bin/sh
# common.sh — sourced by all Altair Linux build scripts.
# Do not execute directly.
#
# Usage at top of every build.sh:
#   . "$(dirname "$0")/../common.sh"
#   astra_build_init

# ALTAIR_TARGET: triple of the system being built FOR.
# ALTAIR_HOST:   triple of the system that will run the built tools
#                (defaults to ALTAIR_TARGET for native builds).
# ALTAIR_BUILD:  triple of the system performing the build
#                (defaults to ALTAIR_TARGET for native builds).
: "${ALTAIR_TARGET:=x86_64-altair-linux-musl}"
: "${ALTAIR_HOST:=${ALTAIR_TARGET}}"
: "${ALTAIR_BUILD:=${ALTAIR_TARGET}}"

# Abort if DESTDIR is not set.
check_destdir() {
    : "${DESTDIR:?DESTDIR must be set}"
}

# Abort if SOURCE_SHA256 is unset or still a placeholder.
check_sha256() {
    case "${SOURCE_SHA256:-unset}" in
        placeholder-*|unset)
            echo "error: SOURCE_SHA256 is not set or is a placeholder. Refusing to build." >&2
            exit 1
            ;;
    esac
}

# Run both checks — call this at the top of every build.sh.
astra_build_init() {
    check_destdir
    check_sha256
}
