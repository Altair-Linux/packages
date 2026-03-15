#!/bin/sh
set -eu
mkdir -p "$DESTDIR/usr/bin"
cp "$PWD/files/usr/bin/tree" "$DESTDIR/usr/bin/tree"
chmod 0755 "$DESTDIR/usr/bin/tree"