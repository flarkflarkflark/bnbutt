# bnbutt — Beats 'n Breaks Use This Tool

**bnbutt** is a fork of **butt** (Broadcast Using This Tool): a lightweight streaming/recording app for **Icecast** and **Shoutcast**, available on **Windows, Linux, and macOS**.

This fork focuses on:
- A **better, responsive main window UI** (scales on small + large monitors)
- A **separate config file** so it can coexist with butt
- Beats ’n Breaks branding (logo/icons)

## Downloads

Releases are built via GitHub Actions.

- Go to: **Releases** → download your platform build
- Tagging `v*` (e.g. `v0.1`) triggers a full build.

## Config file

bnbutt uses its **own** config file:
- **Windows:** `bnbuttrc`
- **Linux/macOS:** `.bnbuttrc`

So you can install/run it **next to** butt without settings colliding.

## Building from source

### Linux

```bash
sudo apt-get install -y \
  build-essential autoconf automake libtool pkg-config \
  libfltk1.3-dev portaudio19-dev \
  libogg-dev libvorbis-dev libopus-dev libflac-dev \
  libmp3lame-dev libsamplerate0-dev libfdk-aac-dev

autoreconf -fi
./configure
make -j"$(nproc)"
```

### macOS (Homebrew)

```bash
brew install autoconf automake libtool pkg-config \
  fltk portaudio libogg libvorbis opus flac lame libsamplerate fdk-aac

autoreconf -fi
./configure
make -j"$(sysctl -n hw.ncpu)"
```

### Windows (MSYS2/MinGW64)

Use **MSYS2** MinGW64 and install deps (see `.github/workflows/release.yml`), then:

```bash
autoreconf -fi
./configure
make -j"$(nproc)"
```

## Packaging

CI produces:
- **Windows:** portable zip + NSIS installer
- **Linux:** AppImage + Flatpak bundle
- **macOS:** .app (zip) + DMG

See: `.github/workflows/release.yml`

## Credits

- Original project: **butt** by Daniel Nöthen and contributors
- This fork: **bnbutt** (Beats ’n Breaks)
