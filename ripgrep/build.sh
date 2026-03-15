#!/bin/sh
set -eu
mkdir -p "$DESTDIR/usr/bin"
cp "$PWD/files/usr/bin/rg" "$DESTDIR/usr/bin/rg"
chmod 0755 "$DESTDIR/usr/bin/rg"