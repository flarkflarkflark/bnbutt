#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT"

mkdir -p dist

APP_NAME="bnbutt"
APP_PATH="dist/${APP_NAME}.app"
DMG_PATH="dist/bnbutt-macos.dmg"

rm -f "$DMG_PATH"

create-dmg \
  --volname "bnbutt" \
  --window-pos 200 120 \
  --window-size 640 360 \
  --icon-size 128 \
  --icon "${APP_NAME}.app" 160 180 \
  --app-drop-link 480 180 \
  "$DMG_PATH" \
  "dist/"
