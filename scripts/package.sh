#!/usr/bin/env bash
#
# Build a Nexus-ready zip of the preset.
#
# Usage:
#   scripts/package.sh [version]
#
# Examples:
#   scripts/package.sh                # -> dist/AC4BF-OrangeBegone-dev.zip
#   scripts/package.sh v1.0.0         # -> dist/AC4BF-OrangeBegone-v1.0.0.zip
#
set -euo pipefail

# Move to repo root (this script lives in scripts/).
cd "$(dirname "$0")/.."

VERSION="${1:-dev}"
NAME="AC4BF-OrangeBegone"
OUT_DIR="dist"
ZIP_PATH="$(pwd)/${OUT_DIR}/${NAME}-${VERSION}.zip"

# Files that go inside the zip.
FILES=(
  "AC4BF_OrangeBegone.ini"
  "README.md"
  "packaging/INSTALL.txt"
)

for f in "${FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "error: missing expected file: $f" >&2
    exit 1
  fi
done

mkdir -p "$OUT_DIR"
rm -f "$ZIP_PATH"

# Stage into a flat directory so the zip has no nested paths
# (Nexus users just want the .ini and the text files at the top level).
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
for f in "${FILES[@]}"; do
  cp "$f" "$STAGE/"
done

( cd "$STAGE" && zip -r -X "$ZIP_PATH" . >/dev/null )

echo "Built ${OUT_DIR}/${NAME}-${VERSION}.zip"
unzip -l "$ZIP_PATH"
