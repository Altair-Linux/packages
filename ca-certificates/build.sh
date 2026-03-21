#!/bin/sh
set -eu
: "${DESTDIR:?DESTDIR must be set}"
case "${SOURCE_SHA256:-unset}" in
  placeholder-*|unset)
    echo "error: SOURCE_SHA256 is not set or is a placeholder. Refusing to build." >&2
    exit 1 ;;
esac
CERTDIR="${DESTDIR}/etc/ssl/certs"
mkdir -p "${CERTDIR}"
cp cacert.pem "${CERTDIR}/ca-certificates.crt"
chmod 0644 "${CERTDIR}/ca-certificates.crt"
mkdir -p "${DESTDIR}/usr/bin"
ln -sf /usr/bin/c_rehash "${DESTDIR}/usr/bin/update-ca-certificates" 2>/dev/null || true
