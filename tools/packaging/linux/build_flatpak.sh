#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$ROOT"

mkdir -p dist

# Install runtimes (best effort)
flatpak install -y flathub org.freedesktop.Platform//23.08 org.freedesktop.Sdk//23.08 || true

flatpak-builder --force-clean --repo=repo build-dir tools/packaging/linux/org.beatsnbreaks.bnbutt.yml
flatpak build-bundle repo dist/bnbutt.flatpak org.beatsnbreaks.bnbutt
