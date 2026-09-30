#!/usr/bin/env bash
# Renders the brand sources in this folder into the Flutter web app:
#   logo.svg -> web/favicon.png, web/icons/Icon-{192,512}.png, web/logo.svg
#            -> web/icons/Icon-maskable-{192,512}.png (full bleed, safe zone)
#   og.html  -> web/og.png, the 1200x630 link preview
# Needs Google Chrome (headless) and Python 3 with Pillow. Run from anywhere.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
web="$here/../../web"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

chrome=$(command -v google-chrome || command -v chromium || command -v chrome)

shot() { # <file-url> <width> <height> <out.png>
  "$chrome" --headless=new --disable-gpu --hide-scrollbars \
    --default-background-color=00000000 --force-device-scale-factor=1 \
    --window-size="$2,$3" --screenshot="$4" "$1" >/dev/null 2>&1
}

# The maskable icon: square tile, mark shrunk into the 80% safe circle.
sed -e 's/rx="116"/rx="0"/g' \
    -e 's|<g id="mark">|<g id="mark" transform="translate(256 256) scale(0.78) translate(-256 -256)">|' \
    "$here/logo.svg" > "$tmp/maskable.svg"

shot "file://$here/logo.svg" 512 512 "$tmp/logo-512.png"
shot "file://$tmp/maskable.svg" 512 512 "$tmp/maskable-512.png"
shot "file://$here/og.html" 1200 630 "$web/og.png"
cp "$here/logo.svg" "$web/logo.svg"

python3 - "$tmp" "$web" <<'PY'
import sys
from PIL import Image
tmp, web = sys.argv[1], sys.argv[2]
logo = Image.open(f"{tmp}/logo-512.png").convert("RGBA")
mask = Image.open(f"{tmp}/maskable-512.png").convert("RGBA")
for size in (192, 512):
    logo.resize((size, size), Image.LANCZOS).save(f"{web}/icons/Icon-{size}.png", optimize=True)
    mask.resize((size, size), Image.LANCZOS).save(f"{web}/icons/Icon-maskable-{size}.png", optimize=True)
logo.resize((48, 48), Image.LANCZOS).save(f"{web}/favicon.png", optimize=True)
# WhatsApp skips previews much over 300 KB, so keep og.png small.
og = Image.open(f"{web}/og.png").convert("RGB")
og.save(f"{web}/og.png", optimize=True)
if og.size != (1200, 630):
    sys.exit(f"og.png came out {og.size}, expected (1200, 630)")
PY

ls -l "$web/og.png" "$web/favicon.png" "$web/icons/"
