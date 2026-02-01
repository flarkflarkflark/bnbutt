from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
PNG_DIR = ROOT / "assets" / "icons" / "png"
OUT_DIR = ROOT / "assets" / "icons"

sizes_ico = [256, 128, 64, 48, 32, 16]

# Windows .ico
imgs = []
for s in sizes_ico:
    p = PNG_DIR / f"bnbutt-{s}.png"
    imgs.append(Image.open(p).convert("RGBA"))

ico_out = OUT_DIR / "bnbutt.ico"
imgs[0].save(ico_out, format="ICO", sizes=[(i.width, i.height) for i in imgs])
print("Wrote", ico_out)

# macOS .icns (Pillow supports it; needs specific sizes)
# Common icns sizes: 16, 32, 64, 128, 256, 512, 1024
icns_sizes = [16, 32, 64, 128, 256, 512, 1024]
base = Image.open(PNG_DIR / "bnbutt-1024.png").convert("RGBA")
iconset = []
for s in icns_sizes:
    iconset.append(base.resize((s, s), Image.Resampling.LANCZOS))

icns_out = OUT_DIR / "bnbutt.icns"
iconset[0].save(icns_out, format="ICNS", append_images=iconset[1:])
print("Wrote", icns_out)
