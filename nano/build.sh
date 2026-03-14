#!/bin/sh
set -eu
mkdir -p "$DESTDIR/usr/bin"
cp "$PWD/files/usr/bin/nano" "$DESTDIR/usr/bin/nano"
chmod 0755 "$DESTDIR/usr/bin/nano"
