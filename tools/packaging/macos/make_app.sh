#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT"

mkdir -p dist

APP_NAME="bnbutt"
APP_DIR="dist/${APP_NAME}.app"
MACOS_DIR="$APP_DIR/Contents/MacOS"
RES_DIR="$APP_DIR/Contents/Resources"

rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR" "$RES_DIR"

BIN=""
if [ -f "src/butt" ]; then BIN="src/butt"; fi
if [ -f "src/bnbutt" ]; then BIN="src/bnbutt"; fi
if [ -z "$BIN" ]; then
  BIN=$(find . -maxdepth 3 -type f -perm -111 -name 'butt' -o -name 'bnbutt' | head -n1)
fi

cp -v "$BIN" "$MACOS_DIR/bnbutt"
chmod +x "$MACOS_DIR/bnbutt"

cp -v assets/icons/bnbutt.icns "$RES_DIR/bnbutt.icns"

cat > "$APP_DIR/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key>
  <string>bnbutt</string>
  <key>CFBundleDisplayName</key>
  <string>bnbutt</string>
  <key>CFBundleIdentifier</key>
  <string>org.beatsnbreaks.bnbutt</string>
  <key>CFBundleVersion</key>
  <string>0.1</string>
  <key>CFBundleShortVersionString</key>
  <string>0.1</string>
  <key>CFBundleExecutable</key>
  <string>bnbutt</string>
  <key>CFBundleIconFile</key>
  <string>bnbutt</string>
  <key>LSMinimumSystemVersion</key>
  <string>11.0</string>
</dict>
</plist>
PLIST

# Portable zip (app)
(cd dist && ditto -c -k --sequesterRsrc --keepParent "${APP_NAME}.app" "bnbutt-macos-portable.zip")
