#!/bin/sh
# ncurses/build.sh
# Builds ncurses terminal handling library.
# Required by readline, bash, and many interactive tools.
#
# Prerequisites: musl, gcc, make.
set -eu

. "$(dirname "$0")/../common.sh"
astra_build_init

: "${PREFIX:=/usr}"

./configure \
    --prefix="${PREFIX}" \
    --with-shared \
    --with-normal \
    --without-debug \
    --without-ada \
    --enable-widec \
    --enable-pc-files \
    --with-pkg-config-libdir="${PREFIX}/lib/pkgconfig" \
    --disable-stripping

make -j"${JOBS:-$(nproc)}"
make DESTDIR="${DESTDIR}" install

# Provide non-wide-char symlinks expected by most software.
# Guard each symlink so we don't create dangling links when optional
# components (e.g. C++) are disabled at configure time.
for lib in ncurses ncurses++ form panel menu; do
    if [ -f "${DESTDIR}${PREFIX}/lib/lib${lib}w.so" ]; then
        ln -sf "lib${lib}w.so" "${DESTDIR}${PREFIX}/lib/lib${lib}.so"
    fi
    if [ -f "${DESTDIR}${PREFIX}/lib/pkgconfig/${lib}w.pc" ]; then
        ln -sf "${lib}w.pc" "${DESTDIR}${PREFIX}/lib/pkgconfig/${lib}.pc"
    fi
done

# Only create libcurses.so symlink if libncursesw.so is actually present.
if [ -f "${DESTDIR}${PREFIX}/lib/libncursesw.so" ]; then
    ln -sf libncursesw.so "${DESTDIR}${PREFIX}/lib/libcurses.so"
fi
