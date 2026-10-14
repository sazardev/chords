# Assets de Google Play — Chords 1.6.0

Capturas **reales** de la app (build `prod` release en emulador Android 13),
versiones **editadas** con titular y marco, imágenes de **ambiente** con fotos
reales y **vídeo** promocional. Todo en PNG/JPG sin transparencia, dentro de
los límites de Play (lado 320–3840 px, proporción ≤ 2:1, ≤ 8 MB).

## Qué subir en Play Console (Ficha de la tienda principal)

| Campo de Play Console | Archivo | Tamaño |
|---|---|---|
| Icono de la app | `graphics/icon_512.png` | 512×512 |
| Gráfico destacado | `graphics/feature_graphic_1024x500.png` (alternativa: `_alt`) | 1024×500 |
| Vídeo (URL de YouTube) | `video/chords_promo_1920x1080.mp4` → súbelo a YouTube como **público o no listado**, sin anuncios | 1920×1080, 36 s |
| Capturas de teléfono (2–8) | `edited/phone/01…08` | 1080×1920 |
| Tablet de 7" (hasta 8) | `edited/tablet7/01…08` | 1200×1920 |
| Tablet de 10" (hasta 8) | `edited/tablet10/01…08` | 1600×2560 |
| Chromebook (hasta 8) | `edited/chromebook/01…08` | 1920×1080 |

- `raw/<formato>/` — las mismas pantallas y más (16 por formato), **sin
  editar**, tal cual las pinta la app. Sirven para mezclar con las editadas o
  para otras fichas.
- `lifestyle/` — 4 imágenes 1080×1920 con foto real de guitarra + la app.
  Se pueden usar como capturas de teléfono (p. ej. en la posición 1 o 8) o en
  redes.
- `video/chords_promo_1080x1920.mp4` — versión vertical para YouTube Shorts,
  Reels o TikTok.

Orden recomendado de capturas: inicio → jam → escalas → cancionero → acorde
→ teoría → juegos → géneros (las dos primeras son las que más se ven).

## Créditos y licencias

- Fotos de `lifestyle/` y del gráfico destacado: **CC0** (dominio público) vía
  Wikimedia Commons / Unsplash. Sin caras reconocibles ni marcas visibles.
  - Gabriel Gurrola — *Acoustic guitar player in pale light*
  - Brandon Wilson — *Guitar player in a garden*
  - Matheus Ferrero — *My first guitar*
  - Junior Pereira — *Guitar on patterned blankets*
- Música del vídeo: original, sintetizada (Karplus-Strong) para este vídeo;
  sin samples de terceros.
- Tipografía: Outfit (SIL Open Font License).

## Regenerar

`src/` contiene los scripts usados (captura por adb + deep links, montaje
HTML→PNG con Chrome headless, música y vídeo con ffmpeg). Las rutas apuntan al
directorio temporal de la sesión en la que se generaron: ajústalas antes de
volver a ejecutarlos.
