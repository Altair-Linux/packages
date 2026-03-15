#!/bin/sh
set -eu
mkdir -p "$DESTDIR/usr/bin"
cp "$PWD/files/usr/bin/htop" "$DESTDIR/usr/bin/htop"
chmod 0755 "$DESTDIR/usr/bin/htop"