#!/bin/sh
set -eu
mkdir -p "$DESTDIR/usr/bin"
cp "$PWD/files/usr/bin/curl" "$DESTDIR/usr/bin/curl"
chmod 0755 "$DESTDIR/usr/bin/curl"