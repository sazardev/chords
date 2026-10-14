"""Pista original para el vídeo: guitarra acústica rasgueada (Karplus-Strong),
bajo y shaker, progresión pop G–D–Em–C a 100 BPM. Sin samples de terceros."""
import sys
import wave

import numpy as np

SR = 44100
BPM = 100
BEAT = 60 / BPM
rng = np.random.default_rng(7)


def ks(freq, dur, amp, decay=0.996, bright=0.5):
    n = int(SR / freq)
    buf = rng.uniform(-1, 1, n)
    # Púa más o menos brillante: filtra el ruido inicial.
    buf = bright * buf + (1 - bright) * np.convolve(buf, np.ones(3) / 3, 'same')
    total = int(SR * dur)
    out = np.empty(total)
    b = buf.copy()
    i = 0
    while i < total:
        k = min(n, total - i)
        out[i:i + k] = b[:k]
        b = decay * 0.5 * (b + np.roll(b, -1))
        i += n
    return out * amp


def midi(m):
    return 440 * 2 ** ((m - 69) / 12)


# Voicings abiertos (MIDI, de grave a agudo).
CHORDS = {
    'G': [43, 47, 50, 55, 59, 67],
    'D': [50, 57, 62, 66],
    'Em': [40, 47, 52, 55, 59, 64],
    'C': [48, 52, 55, 60, 64],
}
BASS = {'G': 31, 'D': 38, 'Em': 28, 'C': 36}
# Rasgueo D · D U · U D U (corcheas), dirección y fuerza.
PATTERN = [(0, 'D', 1.0), (2, 'D', .8), (3, 'U', .55), (5, 'U', .6), (6, 'D', .85), (7, 'U', .5)]


def strum(mix, t, notes, direction, vel):
    order = notes if direction == 'D' else notes[::-1]
    for j, m in enumerate(order):
        start = int((t + j * 0.011) * SR)
        s = ks(midi(m), 2.2, 0.16 * vel, decay=0.9965, bright=0.75 if direction == 'U' else 0.55)
        end = min(len(mix), start + len(s))
        mix[start:end] += s[:end - start]


def main(out, seconds):
    mix = np.zeros(int(SR * (seconds + 3)))
    prog = ['G', 'D', 'Em', 'C']
    bars = int(seconds / (4 * BEAT)) + 1
    for bar in range(bars):
        chord = prog[bar % 4]
        t0 = bar * 4 * BEAT
        intro = bar < 1
        for eighth, d, v in PATTERN:
            if intro and eighth > 0:
                continue
            strum(mix, t0 + eighth * BEAT / 2, CHORDS[chord], d, v)
        if not intro:
            for beat in (0, 2, 2.5):
                s = ks(midi(BASS[chord]), 1.2, 0.35, decay=0.998, bright=0.2)
                st = int((t0 + beat * BEAT) * SR)
                mix[st:st + len(s)] += s[:len(mix) - st]
            # Shaker suave en corcheas.
            for e in range(8):
                st = int((t0 + e * BEAT / 2) * SR)
                n = int(0.05 * SR)
                env = np.exp(-np.linspace(0, 6, n))
                noise = np.diff(rng.uniform(-1, 1, n + 1)) * env * (0.05 if e % 2 else 0.03)
                mix[st:st + n] += noise
    # Reverb sencilla (ecos cortos) y final.
    for d, g in ((0.031, .25), (0.047, .2), (0.083, .15), (0.137, .1)):
        k = int(d * SR)
        mix[k:] += g * mix[:-k]
    mix = mix[:int(SR * seconds)]
    fade = int(SR * 2.5)
    mix[-fade:] *= np.linspace(1, 0, fade)
    mix[:int(SR * .05)] *= np.linspace(0, 1, int(SR * .05))
    mix = mix / np.max(np.abs(mix)) * 0.89
    pcm = (np.stack([mix, np.roll(mix, int(0.012 * SR)) * 0.96], 1) * 32767).astype('<i2')
    with wave.open(out, 'w') as w:
        w.setnchannels(2)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(pcm.tobytes())


if __name__ == '__main__':
    main(sys.argv[1], float(sys.argv[2]))
