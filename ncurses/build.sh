#!/bin/sh
set -eu
: "${DESTDIR:?DESTDIR must be set}"
: "${PREFIX:=/usr}"
case "${SOURCE_SHA256:-unset}" in
  placeholder-*|unset)
    echo "error: SOURCE_SHA256 is not set or is a placeholder. Refusing to build." >&2
    exit 1 ;;
esac
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
for lib in ncurses ncurses++ form panel menu; do
    ln -sf "lib${lib}w.so" "${DESTDIR}${PREFIX}/lib/lib${lib}.so"
    ln -sf "${lib}w.pc"    "${DESTDIR}${PREFIX}/lib/pkgconfig/${lib}.pc"
done
ln -sf libcursesw.so "${DESTDIR}${PREFIX}/lib/libcurses.so"
