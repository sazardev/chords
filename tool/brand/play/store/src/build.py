"""Genera los assets editados de Play Store a partir de capturas reales.

Cada pieza es una página HTML que Chrome headless renderiza a PNG del tamaño
exacto que pide Google Play.
"""
import os
import subprocess
import sys

S = '/tmp/claude-1000/-home-sazar-Documents-chords/8b0d1e24-674a-47e0-a2b1-877d7935a0f6/scratchpad'
GEN = f'{S}/gen'
RAW = f'{S}/raw'
PHOTOS = f'{S}/photos'
OUT = sys.argv[1] if len(sys.argv) > 1 else f'{S}/out'

# Paleta coherente con la app (Material 3, semilla verde + rosa/lila) y la
# marca (morado del icono).
CSS = """
@font-face { font-family: Outfit; src: url(outfit.woff2) format('woff2'); font-weight: 100 900; }
:root {
  --deep: #00221C; --deep2: #00382F; --green: #006B5A; --mint: #94F2DB;
  --mint2: #C6FFEF; --pink: #FFD8E8; --lilac: #E9DDFF; --brand: #6750A4;
}
* { box-sizing: border-box; margin: 0; padding: 0; }
html, body { width: 100%; height: 100%; overflow: hidden; }
body { font-family: Outfit, sans-serif; color: #fff; position: relative;
  background: radial-gradient(120% 70% at 85% 0%, #0E5E4F 0%, transparent 60%),
              radial-gradient(90% 60% at 0% 100%, #3A2A6E 0%, transparent 65%),
              linear-gradient(160deg, var(--deep2) 0%, var(--deep) 100%); }
.glow { position: absolute; border-radius: 50%; filter: blur(var(--b, 80px)); opacity: .55; }
.strings { position: absolute; inset: 0; opacity: .07;
  background: repeating-linear-gradient(90deg, transparent 0 calc(var(--sg) - 2px), #fff calc(var(--sg) - 2px) var(--sg)); }
.head { position: absolute; left: 0; right: 0; text-align: center; padding: 0 7%; }
.kicker { display: inline-flex; align-items: center; gap: .5em; font-weight: 600;
  letter-spacing: .06em; text-transform: uppercase; color: var(--deep);
  background: var(--mint); border-radius: 999px; padding: .35em 1em; }
h1 { text-wrap: balance; font-weight: 800; line-height: 1.02; letter-spacing: -.02em; margin-top: .3em; }
h1 em { font-style: normal; color: var(--mint); }
.sub { text-wrap: balance; font-weight: 400; opacity: .85; margin-top: .45em; line-height: 1.25; }
.device { position: absolute; background: #0B0F0E; box-shadow:
  0 0 0 2px #2A3532, 0 40px 90px rgba(0,0,0,.55), 0 0 120px rgba(148,242,219,.18); }
.device img { display: block; width: 100%; height: 100%; object-fit: cover; }
.screen { overflow: hidden; width: 100%; height: 100%; }
.photo { position: absolute; inset: 0; background-size: cover; background-position: center; }
.shade { position: absolute; inset: 0; }
.chip { display: inline-block; font-weight: 600; border-radius: 999px; padding: .3em .9em;
  margin: .2em; background: rgba(255,255,255,.12); border: 1px solid rgba(255,255,255,.22); }
.logo { display: inline-flex; align-items: center; gap: .45em; font-weight: 800; }
.logo img { border-radius: 24%; }
"""


def page(w, h, body, extra=''):
    return f"""<!doctype html><html><head><meta charset="utf-8">
<style>{CSS}{extra}</style></head>
<body style="width:{w}px;height:{h}px">{body}</body></html>"""


def render(name, w, h, html):
    src = f"{GEN}/_{name.replace('/', '_')}.html"
    with open(src, 'w') as f:
        f.write(html)
    out = f'{OUT}/{name}.png'
    os.makedirs(os.path.dirname(out), exist_ok=True)
    subprocess.run([
        'google-chrome-stable', '--headless=new', '--disable-gpu',
        '--hide-scrollbars', '--allow-file-access-from-files',
        '--force-device-scale-factor=1', f'--window-size={w},{h}',
        '--virtual-time-budget=4000', f'--screenshot={out}', f'file://{src}',
    ], check=True, capture_output=True)
    # Play no admite transparencia: se aplana sobre el fondo.
    subprocess.run(['magick', out, '-background', '#00221C', '-alpha', 'remove',
                    '-alpha', 'off', '-crop', f'{w}x{h}+0+0', '+repage', out], check=True)
    print('ok', name)


def glows(w, h):
    return f"""
<div class="glow" style="width:{w*.7}px;height:{w*.7}px;left:{-w*.25}px;top:{h*.45}px;background:#6750A4;--b:{w*.12}px"></div>
<div class="glow" style="width:{w*.6}px;height:{w*.6}px;right:{-w*.2}px;top:{-w*.15}px;background:#1FA88A;--b:{w*.12}px"></div>
<div class="strings" style="--sg:{w/6:.0f}px"></div>"""


def head(w, top, kicker, title, sub, scale=1.0):
    k = w * .030 * scale
    return f"""<div class="head" style="top:{top}px">
<span class="kicker" style="font-size:{k:.0f}px">{kicker}</span>
<h1 style="font-size:{w*.092*scale:.0f}px">{title}</h1>
<p class="sub" style="font-size:{w*.040*scale:.0f}px">{sub}</p></div>"""


def portrait(name, w, h, shot, kicker, title, sub, dev_h=.66, radius=.075,
             bezel=.018, scale=1.0, top=.055):
    """Titular arriba y dispositivo abajo, con fondo de marca."""
    sw, sh = map(int, subprocess.check_output(
        ['magick', 'identify', '-format', '%w %h', shot]).split())
    dh = h * dev_h
    dw = dh * sw / sh
    if dw > w * .86:
        dw = w * .86
        dh = dw * sh / sw
    b = dw * bezel
    left = (w - dw - 2 * b) / 2
    topd = h - dh - 2 * b - h * .035
    body = glows(w, h) + head(w, h * top, kicker, title, sub, scale) + f"""
<div class="device" style="left:{left}px;top:{topd}px;width:{dw+2*b}px;height:{dh+2*b}px;
  padding:{b}px;border-radius:{dw*radius}px">
<div class="screen" style="border-radius:{dw*radius - b}px"><img src="{shot}"></div></div>"""
    render(name, w, h, page(w, h, body))


def landscape(name, w, h, shot, kicker, title, sub):
    """Titular a la izquierda y portátil a la derecha (Chromebook)."""
    dw = w * .55
    dh = dw * 1080 / 1920
    b = dw * .02
    left = w - dw - 2 * b - w * .04
    top = (h - dh - 2 * b) / 2 - h * .03
    body = glows(w, h) + f"""
<div style="position:absolute;left:{w*.055}px;top:0;bottom:0;width:{w*.30}px;display:flex;flex-direction:column;justify-content:center">
<span class="kicker" style="font-size:{w*.0125:.0f}px;align-self:flex-start">{kicker}</span>
<h1 style="font-size:{w*.040:.0f}px">{title}</h1>
<p class="sub" style="font-size:{w*.017:.0f}px">{sub}</p></div>
<div class="device" style="left:{left}px;top:{top}px;width:{dw+2*b}px;height:{dh+2*b}px;padding:{b}px;border-radius:{b*1.6}px">
<div class="screen" style="border-radius:{b*.5}px"><img src="{shot}"></div></div>
<div style="position:absolute;left:{left - dw*.06}px;top:{top+dh+2*b}px;width:{dw*1.12+2*b}px;height:{h*.035}px;
  background:linear-gradient(#3A4542,#151B1A);border-radius:0 0 {h*.03}px {h*.03}px;box-shadow:0 30px 60px rgba(0,0,0,.5)"></div>"""
    render(name, w, h, page(w, h, body))


def lifestyle(name, w, h, photo, shot, title, sub, pos='center', tilt=-6,
              dev_w=.50, align='left'):
    """Foto real de fondo con el teléfono encima: imagen de ambiente."""
    dw = w * dev_w
    dh = dw * 1920 / 1080
    b = dw * .02
    body = f"""
<div class="photo" style="background-image:url({photo});background-position:{pos}"></div>
<div class="shade" style="background:linear-gradient(180deg,rgba(0,34,28,.92) 0%,rgba(0,34,28,.55) 32%,rgba(0,34,28,.15) 60%,rgba(0,34,28,.75) 100%)"></div>
<div class="head" style="top:{h*.055}px;text-align:{align}">
<h1 style="font-size:{w*.088:.0f}px">{title}</h1>
<p class="sub" style="font-size:{w*.040:.0f}px">{sub}</p></div>
<div class="device" style="right:{w*.08}px;bottom:{-dh*.10}px;width:{dw+2*b}px;height:{dh+2*b}px;padding:{b}px;
  border-radius:{dw*.075}px;transform:rotate({tilt}deg);transform-origin:bottom right">
<div class="screen" style="border-radius:{dw*.075-b}px"><img src="{shot}"></div></div>"""
    render(name, w, h, page(w, h, body))


PHONE = [
    ('01_home', 'Tu escuela de guitarra', 'Aprende guitarra <em>a tu ritmo</em>', 'Acordes, teoría, juegos y jam en una sola app'),
    ('02_jam', 'Jam guiado', 'Toca con <em>la banda</em>', 'Rasgueo, bajo y metrónomo: tú pones la guitarra'),
    ('03_scales', 'Escalas y posiciones', 'Domina <em>el mástil</em>', 'Pentatónicas, modos y las 5 cajas, en los 12 tonos'),
    ('05_song', 'Cancionero', 'Canciones para <em>tocar ya</em>', 'Acordes por compás, letra y cambio de tono'),
    ('06_chord', '156 acordes · 561 posiciones', 'Cada acorde, <em>bien explicado</em>', 'Diagrama, dedos, sonido real y práctica con micrófono'),
    ('04_theory', '14 lecciones', 'Teoría que <em>se entiende</em>', 'Tónica, intervalos, escalas, armonía y CAGED'),
    ('08_games', '22 minijuegos', 'Entrena <em>tu oído</em>', 'Notas, intervalos, acordes y progresiones jugando'),
    ('09_genre', '15 géneros', 'Del country <em>al metal</em>', 'Ritmo, rasgueo, escalas y progresiones de cada estilo'),
]

LIFESTYLE = [
    ('life_01', 'p00.jpg', '02_jam', 'Tu guitarra.<br><em>Tu banda.</em>', 'Toca encima de la progresión y la app te acompaña', '30% center'),
    ('life_02', 'p03.jpg', '03_scales', 'Improvisa <em>sin miedo</em>', 'Las escalas, dibujadas sobre tu mástil', '40% center'),
    ('life_03', 'p05.jpg', '05_song', 'De la app <em>a tus manos</em>', 'Canciones con acordes y letra, listas para tocar', '35% center'),
    ('life_04', 'p02.jpg', '01_home', 'Aprende guitarra <em>de verdad</em>', 'Acordes, teoría, juegos y jam', '60% center'),
]


def feature(name, photo, shot, variant):
    """Gráfico destacado 1024x500: marca a la izquierda, foto y app a la derecha."""
    w, h = 1024, 500
    bg = (f'<div class="photo" style="left:38%;background-image:url({photo});background-position:30% 40%"></div>'
          '<div class="shade" style="background:linear-gradient(90deg,#00221C 36%,rgba(0,34,28,.75) 52%,rgba(0,34,28,.15) 80%,rgba(0,34,28,.35) 100%)"></div>'
          if variant == 'photo' else glows(w, h))
    dw = 168; dh = dw * 1920 / 1080; b = 5
    body = bg + f"""
<div style="position:absolute;left:56px;top:0;bottom:0;width:470px;display:flex;flex-direction:column;justify-content:center">
<div class="logo" style="font-size:40px"><img src="icon.svg" width="58" height="58">Chords</div>
<h1 style="font-size:52px;margin-top:14px">Aprende guitarra <em>tocando</em></h1>
<p class="sub" style="font-size:21px;margin-top:10px">Acordes · Escalas · Teoría · Jam guiado · Juegos</p>
</div>
<div class="device" style="right:84px;top:88px;width:{dw+2*b}px;height:{dh+2*b}px;padding:{b}px;border-radius:26px;transform:rotate(6deg)">
<div class="screen" style="border-radius:21px"><img src="{shot}"></div></div>"""
    render(name, w, h, page(w, h, body))


def main():
    feature('feature_graphic_1024x500', f'{PHOTOS}/p00.jpg', f'{RAW}/phone/02_jam.png', 'photo')
    feature('feature_graphic_1024x500_alt', '', f'{RAW}/phone/03_scales.png', 'brand')
    phone, t7, t10, cb = (f'{RAW}/{p}' for p in ('phone', 'tablet7', 'tablet10', 'chromebook'))
    for i, (shot, k, t, s) in enumerate(PHONE, 1):
        portrait(f'phone/{i:02d}_{shot[3:]}', 1080, 1920, f'{phone}/{shot}.png', k, t, s)
        portrait(f'tablet7/{i:02d}_{shot[3:]}', 1200, 1920, f'{t7}/{shot}.png', k, t, s,
                 dev_h=.645, radius=.045, bezel=.022, scale=.92)
        portrait(f'tablet10/{i:02d}_{shot[3:]}', 1600, 2560, f'{t10}/{shot}.png', k, t, s,
                 dev_h=.645, radius=.04, bezel=.02, scale=.92)
        landscape(f'chromebook/{i:02d}_{shot[3:]}', 1920, 1080, f'{cb}/{shot}.png', k, t, s)
    for name, photo, shot, t, s, pos in LIFESTYLE:
        lifestyle(f'lifestyle/{name}', 1080, 1920, f'{PHOTOS}/{photo}', f'{phone}/{shot}.png', t, s, pos)


if __name__ == '__main__':
    main()
