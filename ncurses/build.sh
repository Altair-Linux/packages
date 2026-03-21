#!/bin/sh
# ncurses/build.sh
# Builds ncurses terminal handling library.
# Required by readline, bash, and many interactive tools.
#
# Prerequisites: musl, gcc, make.
set -eu

: "${PREFIX:=/usr}"

. "$(dirname "$0")/../common.sh"
astra_build_init

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
for lib in ncurses ncurses++ form panel menu; do
    ln -sf "lib${lib}w.so" "${DESTDIR}${PREFIX}/lib/lib${lib}.so"
    ln -sf "${lib}w.pc"    "${DESTDIR}${PREFIX}/lib/pkgconfig/${lib}.pc"
done
# Only create libcurses.so symlink if libncursesw.so is actually present
if [ -f "${DESTDIR}${PREFIX}/lib/libncursesw.so" ]; then
    ln -sf libncursesw.so "${DESTDIR}${PREFIX}/lib/libcurses.so"
fi
