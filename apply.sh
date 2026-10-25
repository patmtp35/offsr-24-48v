#!/usr/bin/env bash
# Clone le dépôt de Seby sur un commit précis, applique le patch 24/48 V, copie le composant patché.
# UPSTREAM_REF=main ./apply.sh   pour tester la dernière version amont.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
REF="${UPSTREAM_REF:-12fb7b5}"
rm -rf "$HERE/build" && mkdir -p "$HERE/build"
git clone https://github.com/SeByDocKy/myESPhome.git "$HERE/build/upstream"
(cd "$HERE/build/upstream" && git checkout --quiet "$REF" && \
  patch -p1 < "$HERE/patches/offsr-24-48v.patch")
mkdir -p "$HERE/build/components"
cp -r "$HERE/build/upstream/components/offsr" "$HERE/build/components/offsr"
echo "OK : composant patché ($REF) dans $HERE/build/components/offsr"
