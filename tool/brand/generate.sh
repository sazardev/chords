#!/usr/bin/env bash
# Regenera los PNG de marca (Android, web y Play Store) desde los SVG fuente.
# Uso: bash tool/brand/generate.sh
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
brand="$root/tool/brand"
res="$root/android/app/src/main/res"

render() { # <svg> <px> <out>
  rsvg-convert -w "$2" -h "$2" "$1" -o "$3"
}

flatten() { # <png>: elimina el canal alfa (Play no acepta transparencia)
  magick "$1" -background "#6750A4" -alpha remove -alpha off "$1"
}

# Android: icono legacy con esquinas redondeadas + capa foreground adaptativa.
for spec in mdpi:48 hdpi:72 xhdpi:96 xxhdpi:144 xxxhdpi:192; do
  render "$brand/icon_round.svg" "${spec##*:}" "$res/mipmap-${spec%%:*}/ic_launcher.png"
done
for spec in mdpi:108 hdpi:162 xhdpi:216 xxhdpi:324 xxxhdpi:432; do
  render "$brand/foreground.svg" "${spec##*:}" "$res/mipmap-${spec%%:*}/ic_launcher_foreground.png"
done

# Web: PWA + favicon.
render "$brand/icon.svg" 192 "$root/web/icons/Icon-192.png"
render "$brand/icon.svg" 512 "$root/web/icons/Icon-512.png"
cp "$root/web/icons/Icon-192.png" "$root/web/icons/Icon-maskable-192.png"
cp "$root/web/icons/Icon-512.png" "$root/web/icons/Icon-maskable-512.png"
render "$brand/icon_round.svg" 64 "$root/web/favicon.png"

# Play Store: icono 512 y gráfico destacado 1024x500.
mkdir -p "$brand/play"
render "$brand/icon.svg" 512 "$brand/play/icon_512.png"
flatten "$brand/play/icon_512.png"
rsvg-convert -w 1024 -h 500 "$brand/feature_graphic.svg" \
  -o "$brand/play/feature_graphic_1024x500.png"
flatten "$brand/play/feature_graphic_1024x500.png"

echo "Marca regenerada en android res, web/ y tool/brand/play/."
