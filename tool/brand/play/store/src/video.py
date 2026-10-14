"""Monta el vídeo promocional (16:9 y 9:16) con clips reales de la app."""
import os
import subprocess
import sys

sys.path.insert(0, os.path.dirname(__file__))
import build  # noqa: E402

S = build.S
CLIPS = f'{S}/video/clips'
WORK = f'{S}/video/work'
OUT = sys.argv[1] if len(sys.argv) > 1 else f'{S}/out/video'
FPS = 30
XF = 0.45  # duración del fundido entre escenas

SCENES = [
    # clip, segundos, etiqueta, titular, subtítulo
    ('home', 4.2, 'Tu escuela de guitarra', 'Aprende guitarra <em>a tu ritmo</em>', 'Acordes, teoría, juegos y jam'),
    ('jam', 5.2, 'Jam guiado', 'Toca con <em>la banda</em>', 'Rasgueo, bajo y metrónomo en 23 progresiones'),
    ('scales', 5.0, 'Escalas y posiciones', 'Domina <em>el mástil</em>', 'Pentatónicas, modos y las 5 cajas'),
    ('jamsong', 4.6, 'Cancionero', 'Canciones <em>con letra</em>', 'Acordes por compás, listos para tocar'),
    ('chord', 3.6, '156 acordes · 561 posiciones', 'Cada acorde, <em>con sonido</em>', 'Diagrama, dedos y práctica con micrófono'),
    ('theory', 3.7, '14 lecciones', 'Teoría que <em>se entiende</em>', 'Tónica, escalas, armonía y CAGED'),
    ('game', 3.8, '22 minijuegos', 'Entrena <em>tu oído</em>', 'Notas, intervalos y progresiones'),
    ('genres', 3.6, '15 géneros', 'Del country <em>al metal</em>', 'Ritmo y progresiones de cada estilo'),
]


def run(cmd):
    subprocess.run(cmd, check=True, capture_output=True)


def layouts(fmt):
    """Geometría del teléfono (x, y, ancho, alto de pantalla, bisel)."""
    if fmt == 'h':
        sh = 900
        sw = sh * 1080 // 1920 // 2 * 2
        return 1920, 1080, (1920 - sw - 250, 90, sw, sh, 12)
    sh = 1240
    sw = sh * 1080 // 1920 // 2 * 2
    return 1080, 1920, ((1080 - sw) // 2, 560, sw, sh, 14)


def background(name, fmt, kicker, title, sub):
    w, h, (x, y, sw, sh, b) = layouts(fmt)
    if fmt == 'h':
        text = f"""<div style="position:absolute;left:{w*.07}px;top:0;bottom:0;width:{w*.4}px;display:flex;flex-direction:column;justify-content:center">
<span class="kicker" style="font-size:24px;align-self:flex-start">{kicker}</span>
<h1 style="font-size:92px">{title}</h1><p class="sub" style="font-size:36px">{sub}</p></div>"""
    else:
        text = build.head(w, 110, kicker, title, sub)
    body = build.glows(w, h) + text + f"""
<div class="device" style="left:{x-b}px;top:{y-b}px;width:{sw+2*b}px;height:{sh+2*b}px;border-radius:{sw*.075+b}px"></div>"""
    build.OUT = WORK
    build.render(name, w, h, build.page(w, h, body))
    return f'{WORK}/{name}.png'


def card(name, fmt, closing):
    w, h, _ = layouts(fmt)
    big = 1.0 if fmt == 'h' else 1.15
    line = ('Descárgala en <em>Google Play</em>' if closing
            else 'Aprende guitarra <em>tocando</em>')
    sub = ('Acordes · Escalas · Teoría · Jam · Juegos' if closing
           else '156 acordes · 22 canciones · 22 juegos')
    body = build.glows(w, h) + f"""
<div style="position:absolute;inset:0;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:0 6%">
<img src="{build.GEN}/icon.svg" style="width:{180*big}px;height:{180*big}px;border-radius:24%;box-shadow:0 30px 80px rgba(0,0,0,.45)">
<div style="font-size:{110*big}px;font-weight:800;margin-top:28px;letter-spacing:-.02em">Chords</div>
<h1 style="font-size:{58*big}px;font-weight:700;margin-top:6px">{line}</h1>
<p class="sub" style="font-size:{32*big}px;margin-top:14px">{sub}</p></div>"""
    build.OUT = WORK
    build.render(name, w, h, build.page(w, h, body))
    return f'{WORK}/{name}.png'


def mask(fmt):
    _, _, (_, _, sw, sh, _) = layouts(fmt)
    path = f'{WORK}/mask_{fmt}.png'
    r = int(sw * .075)
    run(['magick', '-size', f'{sw}x{sh}', 'xc:black', '-fill', 'white', '-draw',
         f'roundrectangle 0,0 {sw-1},{sh-1} {r},{r}', path])
    return path


def scene(fmt, idx, clip, dur, bg):
    _, _, (x, y, sw, sh, _) = layouts(fmt)
    out = f'{WORK}/{fmt}_{idx:02d}.mp4'
    fil = (f'[1:v]fps={FPS},scale={sw}:{sh}:flags=lanczos,tpad=stop_mode=clone:stop_duration=10,'
           f'trim=duration={dur},setpts=PTS-STARTPTS,format=rgba[c];'
           f'[2:v]scale={sw}:{sh},format=gray[m];[c][m]alphamerge[cm];'
           f'[0:v][cm]overlay={x}:{y}:shortest=1,format=yuv420p[v]')
    run(['ffmpeg', '-y', '-loop', '1', '-framerate', str(FPS), '-t', str(dur), '-i', bg,
         '-i', f'{CLIPS}/{clip}.mp4', '-loop', '1', '-i', mask(fmt),
         '-filter_complex', fil, '-map', '[v]', '-t', str(dur), '-r', str(FPS),
         '-c:v', 'libx264', '-crf', '16', '-preset', 'medium', out])
    return out, dur


def still(fmt, name, png, dur):
    out = f'{WORK}/{fmt}_{name}.mp4'
    run(['ffmpeg', '-y', '-loop', '1', '-framerate', str(FPS), '-t', str(dur), '-i', png,
         '-vf', 'format=yuv420p', '-c:v', 'libx264', '-crf', '16', out])
    return out, dur


def assemble(fmt, parts, music, out):
    inputs, fil, prev, offset = [], [], '0:v', 0.0
    for i, (path, dur) in enumerate(parts):
        inputs += ['-i', path]
        if i == 0:
            offset = dur
            continue
        offset -= XF
        tag = f'x{i}'
        fil.append(f'[{prev}][{i}:v]xfade=transition=fade:duration={XF}:offset={offset:.3f}[{tag}]')
        prev, offset = tag, offset + dur
    total = offset
    fil.append(f'[{prev}]fade=t=out:st={total-0.6:.3f}:d=0.6[v]')
    inputs += ['-i', music]
    na = len(parts)
    fil.append(f'[{na}:a]atrim=duration={total:.3f},afade=t=out:st={total-2:.3f}:d=2[a]')
    run(['ffmpeg', '-y', *inputs, '-filter_complex', ';'.join(fil), '-map', '[v]', '-map', '[a]',
         '-c:v', 'libx264', '-crf', '18', '-preset', 'slow', '-pix_fmt', 'yuv420p', '-r', str(FPS),
         '-c:a', 'aac', '-b:a', '192k', '-movflags', '+faststart', out])
    return total


def main():
    os.makedirs(WORK, exist_ok=True)
    os.makedirs(OUT, exist_ok=True)
    total = 3.0 + sum(d for _, d, *_ in SCENES) + 3.6 - XF * (len(SCENES) + 1)
    music = f'{WORK}/music.wav'
    run(['python3', f'{build.GEN}/music.py', music, f'{total + 1:.2f}'])
    for fmt, name in (('h', 'chords_promo_1920x1080.mp4'), ('v', 'chords_promo_1080x1920.mp4')):
        parts = [still(fmt, 'intro', card(f'{fmt}_intro', fmt, False), 3.0)]
        for i, (clip, dur, k, t, s) in enumerate(SCENES):
            parts.append(scene(fmt, i, clip, dur, background(f'{fmt}_bg_{i:02d}', fmt, k, t, s)))
        parts.append(still(fmt, 'outro', card(f'{fmt}_outro', fmt, True), 3.6))
        length = assemble(fmt, parts, music, f'{OUT}/{name}')
        print('video', name, f'{length:.1f}s')


if __name__ == '__main__':
    main()
