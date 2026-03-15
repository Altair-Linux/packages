#!/bin/sh
set -eu
mkdir -p "$DESTDIR/usr/bin"
cp "$PWD/files/usr/bin/jq" "$DESTDIR/usr/bin/jq"
chmod 0755 "$DESTDIR/usr/bin/jq"