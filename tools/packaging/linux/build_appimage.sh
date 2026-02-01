#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT"

mkdir -p dist

# Download linuxdeploy
LINUXDEPLOY="$ROOT/tools/packaging/linux/linuxdeploy-x86_64.AppImage"
if [ ! -f "$LINUXDEPLOY" ]; then
  curl -L -o "$LINUXDEPLOY" https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
  chmod +x "$LINUXDEPLOY"
fi

# Build AppImage from AppDir
export VERSION="${GITHUB_REF_NAME:-0.1}"

"$LINUXDEPLOY" --appdir AppDir --output appimage

# linuxdeploy outputs in cwd
APPIMAGE=$(ls ./*.AppImage | head -n1)
if [ -z "$APPIMAGE" ]; then
  echo "No AppImage produced" >&2
  exit 1
fi

mv -v "$APPIMAGE" dist/"bnbutt-${VERSION}-linux-x86_64.AppImage"
