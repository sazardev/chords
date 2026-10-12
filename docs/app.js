// Chords — sitio de presentación. Datos del banco y render de diagramas.
'use strict';

/** Banco de ejemplo extraído del generador (mismas posiciones que la app). */
const CHORDS = [
  {
    id: 'C-maj',
    name: 'C',
    quality: 'Mayor',
    difficulty: 1,
    positions: 5,
    position: 'Forma de Do',
    frets: [-1, 3, 2, 0, 1, 0],
    barre: null,
  },
  {
    id: 'G-maj',
    name: 'G',
    quality: 'Mayor',
    difficulty: 2,
    positions: 5,
    position: 'Forma de Sol',
    frets: [3, 2, 0, 0, 0, 3],
    barre: null,
  },
  {
    id: 'D-maj',
    name: 'D',
    quality: 'Mayor',
    difficulty: 2,
    positions: 5,
    position: 'Forma de Re',
    frets: [-1, -1, 0, 2, 3, 2],
    barre: null,
  },
  {
    id: 'E-maj',
    name: 'E',
    quality: 'Mayor',
    difficulty: 1,
    positions: 5,
    position: 'Forma de Mi',
    frets: [0, 2, 2, 1, 0, 0],
    barre: null,
  },
  {
    id: 'E-min',
    name: 'Em',
    quality: 'Menor',
    difficulty: 1,
    positions: 5,
    position: 'Forma de Mi menor',
    frets: [0, 2, 2, 0, 0, 0],
    barre: null,
  },
  {
    id: 'A-min',
    name: 'Am',
    quality: 'Menor',
    difficulty: 1,
    positions: 5,
    position: 'Forma de La menor',
    frets: [-1, 0, 2, 2, 1, 0],
    barre: null,
  },
  {
    id: 'F-maj',
    name: 'F',
    quality: 'Mayor',
    difficulty: 3,
    positions: 5,
    position: 'Forma de Mi · traste 1',
    frets: [1, 3, 3, 2, 1, 1],
    barre: { fret: 1, from: 0, to: 5 },
  },
  {
    id: 'B',
    name: 'B',
    quality: 'Mayor',
    difficulty: 3,
    positions: 5,
    position: 'Forma de La · traste 2',
    frets: [-1, 2, 4, 4, 4, 2],
    barre: { fret: 2, from: 1, to: 5 },
  },
  {
    id: 'G-7',
    name: 'G7',
    quality: 'Séptima de dominante',
    difficulty: 1,
    positions: 5,
    position: 'Forma de Sol 7',
    frets: [3, 2, 0, 0, 0, 1],
    barre: null,
  },
  {
    id: 'A-m7',
    name: 'Am7',
    quality: 'Séptima menor',
    difficulty: 2,
    positions: 5,
    position: 'Forma de La m7',
    frets: [-1, 0, 2, 0, 1, 0],
    barre: null,
  },
  {
    id: 'C-maj7',
    name: 'Cmaj7',
    quality: 'Séptima mayor',
    difficulty: 2,
    positions: 5,
    position: 'Forma de Mi maj7 · traste 8',
    frets: [8, 10, 9, 9, 8, 8],
    barre: { fret: 8, from: 0, to: 5 },
  },
];

const FEATURES = [
  {
    icon: 'library',
    title: 'Banco extenso',
    text: '156 acordes (12 raíces × 13 cualidades) y 581 posiciones: cejillas, movibles, power chords, triadas e inversiones.',
  },
  {
    icon: 'sound',
    title: 'Sonido por acorde',
    text: 'Síntesis Karplus‑Strong por cuerda con envolvente realista, mezclada con micro-retardo de rasgueo y codificada a WAV.',
  },
  {
    icon: 'mic',
    title: 'Micrófono en vivo',
    text: 'Captura PCM16 y detector de tono YIN: nota, cents y acordes sugeridos en tiempo real.',
  },
  {
    icon: 'adaptive',
    title: 'Diseño adaptable',
    text: 'Material 3 Expressive: barra inferior en móvil, rail lateral en escritorio, diagramas en espejo para zurdos.',
  },
  {
    icon: 'link',
    title: 'Deep links y query params',
    text: 'chords:// y https://chords.app/... con rutas profundas y parámetros de consulta (raíz, calidad, dificultad, texto).',
  },
  {
    icon: 'flavor',
    title: 'Flavors y calidad',
    text: 'dev, staging y prod con applicationId propio; lint estricto, git hooks pre-commit/pre-push, 25 tests y CLI propia.',
  },
];

const LEARN_FEATURES = [
  {
    icon: 'school',
    title: 'Itinerario por niveles',
    text: 'De los abiertos esenciales al jazz. Progreso persistente por acorde dominado.',
  },
  {
    icon: 'arpegio',
    title: 'Arpegios guiados',
    text: 'Ascendente, descendente, alterno y fingerstyle, sintetizados cuerda por cuerda.',
  },
  {
    icon: 'game',
    title: '17 minijuegos',
    text: 'Adivina la nota, reconoce acordes, aprende el mástil y los dedos, y toca con el micrófono: tres dificultades y estrellas por juego.',
  },
  {
    icon: 'genre',
    title: 'Filtros por género',
    text: 'Pop, Rock, Blues, Funk, Jazz, Balada, Latino y Metal, además de nivel y dificultad.',
  },
];

const TOKENS = [
  { name: 'primary', value: '#6750A4' },
  { name: 'primary-container', value: '#E9DDFF' },
  { name: 'secondary', value: '#625B71' },
  { name: 'tertiary', value: '#7D5260' },
  { name: 'surface', value: '#FEF7FF' },
  { name: 'on-surface', value: '#1D1B20' },
];

const DIFFICULTY = [
  { level: 1, label: 'Principiante' },
  { level: 2, label: 'Fácil' },
  { level: 3, label: 'Intermedio' },
  { level: 4, label: 'Difícil' },
  { level: 5, label: 'Experto' },
];

/** Iconos SVG del sistema de diseño. */
const ICONS = {
  school:
    '<path fill="currentColor" d="M12 3 1 9l4 2.2v6L12 21l7-3.8v-6L23 9l-11-6Zm0 2.3 7.5 4.2L12 13.7 4.5 9.5 12 5.3ZM6 13.1l6 3.3 6-3.3v3.9l-6 3.3-6-3.3v-3.9Z"/>',
  arpegio:
    '<path fill="currentColor" d="M3 17h2v-2H3v2Zm4 0h2v-4H7v4Zm4 0h2V9h-2v8Zm4 0h2V5h-2v12ZM19 17h2v-8h-2v8Z"/>',
  game:
    '<path fill="currentColor" d="M7 7h10a5 5 0 0 1 5 5v3a4 4 0 0 1-4 4h-1v2h-2v-2h-2v2h-2v-2H9v2H7v-2a5 5 0 0 1-5-5v-3a5 5 0 0 1 5-5Zm0 2a3 3 0 0 0-3 3v1h2v-1h2v-1H7Zm10 0h-2v1h2v1h2v-1a3 3 0 0 0-3-3Zm-8 3v2H5v-2h4Zm10 0v2h-4v-2h4Z"/>',
  genre:
    '<path fill="currentColor" d="M12 3v10.6a4 4 0 1 0 2 3.4V7h4V3h-6Z"/>',
  library:
    '<path fill="currentColor" d="M4 4h2v16H4V4Zm4 0h2v16H8V4Zm4 0h2v16h-2V4Zm4 0h2v16h-2V4Zm4 0h2v16h-2V4Z"/>',
  sound:
    '<path fill="currentColor" d="M3 10v4h3l4 4V6L6 10H3Zm11.5-2.5a5 5 0 0 1 0 9v-2a3 3 0 0 0 0-5v-2Zm2.5-2a8 8 0 0 1 0 13v-2a6 6 0 0 0 0-9V5.5Z"/>',
  mic:
    '<path fill="currentColor" d="M12 15a3 3 0 0 0 3-3V6a3 3 0 0 0-6 0v6a3 3 0 0 0 3 3Zm5-3a5 5 0 0 1-10 0H5a7 7 0 0 0 6 6.9V21h2v-2.1A7 7 0 0 0 19 12h-2Z"/>',
  adaptive:
    '<path fill="currentColor" d="M3 5h18v10h-6l3 3h-2l-3-3H8v3H6v-3H3V5Zm0 2v6h16V7H3Z"/>',
  link:
    '<path fill="currentColor" d="M10 13a5 5 0 0 0 7.5.5l3-3a5 5 0 0 0-7-7l-1.7 1.7 1.4 1.4L14 5a3 3 0 0 1 4.2 4.2l-3 3A3 3 0 0 1 11 11l1.7-1.7-1.4-1.4L9.5 9.6a5 5 0 0 0 .5 3.4Zm4-6a5 5 0 0 0-7.5-.5l-3 3a5 5 0 0 0 7 7l1.7-1.7-1.4-1.4L9.5 17a3 3 0 0 1-4.2-4.2l3-3A3 3 0 0 1 11 11L9.3 12.7l1.4 1.4 1.8-1.8a5 5 0 0 0-.5-3.3Z"/>',
  flavor:
    '<path fill="currentColor" d="M12 2 2 7l10 5 10-5-10-5Zm0 8.2L4.8 6.6 12 3.4l7.2 3.2L12 10.2ZM2 12l10 5 10-5v2.6l-10 5-10-5V12Zm0 5 10 5 10-5v2.6L12 23 2 21.2V17Z"/>',
};

const $ = (selector) => document.querySelector(selector);

/** Estrellas de dificultad. */
function stars(level) {
  let out = '<span class="stars" title="Dificultad ' + level + '/5">';
  for (let i = 1; i <= 5; i += 1) {
    out += '<b style="--dot:var(--diff-' + (i <= level ? level : 2) + ')"></b>';
  }
  out += '</span>';
  return out;
}

/** Dibuja un diagrama de diapasón como SVG a partir de los trastes. */
function diagram(chord, width = 104) {
  const stringCount = 6;
  const visibleFrets = 5;
  const padX = 12;
  const padTop = 14;
  const rowHeight = 13;
  const height = padTop + visibleFrets * rowHeight + 6;
  const spacing = (width - padX * 2) / (stringCount - 1);
  const pressed = chord.frets.filter((f) => f > 0);
  const baseFret = pressed.length ? Math.min(...pressed) : 0;
  const startFret = baseFret === 0 ? 1 : baseFret;
  const x = (i) => padX + i * spacing;
  const y = (row) => padTop + row * rowHeight;

  let svg = '<svg class="diagram" width="' + width + '" height="' + height +
    '" viewBox="0 0 ' + width + ' ' + height + '" role="img" aria-label="' +
    chord.position + '">';

  if (startFret > 1) {
    svg += '<text x="' + width / 2 + '" y="8" text-anchor="middle" font-size="8" ' +
      'fill="var(--m3-on-surface-variant)">' + startFret + 'º</text>';
  }

  if (chord.barre && chord.barre.fret - startFret >= 0) {
    const bx0 = x(chord.barre.from);
    const bx1 = x(chord.barre.to);
    const by = y(chord.barre.fret - startFret + 0.5);
    svg += '<rect x="' + bx0 + '" y="' + (by - 5.5) + '" width="' + (bx1 - bx0) +
      '" height="11" rx="5.5" fill="var(--m3-primary)" opacity="0.55"/>';
  }

  for (let i = 0; i <= visibleFrets; i += 1) {
    svg += '<line x1="' + padX + '" y1="' + y(i) + '" x2="' + (width - padX) +
      '" y2="' + y(i) + '" stroke="var(--m3-outline-variant)" stroke-width="' +
      (i === 0 ? 2.6 : 1) + '"/>';
  }
  for (let s = 0; s < stringCount; s += 1) {
    const fx = chord.frets[s];
    svg += '<line x1="' + x(s) + '" y1="' + padTop + '" x2="' + x(s) +
      '" y2="' + y(visibleFrets) + '" stroke="var(--m3-outline-variant)" stroke-width="1.2"/>';
    if (fx === -1) {
      svg += '<text x="' + x(s) + '" y="' + (padTop - 3) +
        '" text-anchor="middle" font-size="9" fill="var(--m3-outline-variant)">×</text>';
    } else if (fx === 0) {
      svg += '<circle cx="' + x(s) + '" cy="' + (padTop - 5) +
        '" r="3.2" fill="none" stroke="var(--in-tune)" stroke-width="1.4"/>';
    } else {
      const fy = y(fx - startFret + 0.5);
      svg += '<circle cx="' + x(s) + '" cy="' + fy + '" r="4.6" fill="var(--m3-primary)"/>';
    }
  }
  return svg + '</svg>';
}

/** Coincidencia aproximada de nota para el mock del afinador (visual). */
function renderFeatures() {
  const host = $('[data-features]');
  host.innerHTML = FEATURES.map(
    (f) => '<article class="feature"><span class="icon"><svg viewBox="0 0 24 24" width="22" height="22">' +
      ICONS[f.icon] + '</svg></span><h3>' + f.title + '</h3><p>' + f.text +
      '</p></article>'
  ).join('');
}

/** Mini tarjetas dentro del mock de teléfono. */
function renderHeroGrid() {
  const picks = ['C-maj', 'G-maj', 'E-min', 'A-min'];
  const host = $('[data-grid]');
  host.innerHTML = picks
    .map((id) => {
      const chord = CHORDS.find((c) => c.id === id);
      return '<div class="mini-card">' + diagram(chord, 80) +
        '<div class="mini-name">' + chord.name + '</div></div>';
    })
    .join('');
}

/** Banco de acordes filtrable por raíz. */
function renderLibrary() {
  const chordsHost = $('[data-chords]');
  const originsHost = $('[data-origins]');
  const origins = ['Todas', ...new Set(CHORDS.map((c) => c.name[0]))];

  const paint = (filter) => {
    const list = filter === 'Todas'
      ? CHORDS
      : CHORDS.filter((c) => c.name[0] === filter);
    chordsHost.innerHTML = list
      .map(
        (c) => '<button class="chord-card" type="button" data-chord="' + c.id +
          '">' + diagram(c) + '<div class="name">' + c.name +
          '</div><div class="quality">' + c.quality +
          '</div><div class="meta">' + stars(c.difficulty) + '<span>' +
          c.positions + ' posiciones</span></div></button>'
      )
      .join('');
    chordsHost.querySelectorAll('[data-chord]').forEach((el) => {
      el.addEventListener('click', () => {
        const chord = CHORDS.find((c) => c.id === el.dataset.chord);
        speak(chord);
      });
    });
  };

  originsHost.innerHTML = origins
    .map(
      (o, i) => '<button class="chip" role="tab" type="button" aria-selected="' +
        (i === 0) + '">' + o + '</button>'
    )
    .join('');
  originsHost.querySelectorAll('.chip').forEach((chip) => {
    chip.addEventListener('click', () => {
      originsHost.querySelectorAll('.chip').forEach((c) =>
        c.setAttribute('aria-selected', String(c === chip))
      );
      paint(chip.textContent);
    });
  });
  paint('Todas');
}

/** Mini sintetizador para la demo web (mismo espíritu que la app). */
let audioContext = null;

function speak(chord) {
  try {
    audioContext = audioContext || new (window.AudioContext || window.webkitAudioContext)();
    const base = 110 * Math.pow(2, (['E', 'F', 'G', 'A', 'B', 'C'].indexOf(chord.name[0]) - 2) / 12 + 2);
    chord.frets.forEach((fret, stringIndex) => {
      if (fret < 0) return;
      const offset = stringIndex * 0.012;
      const freq = base * Math.pow(2, (fret + [0, 5, 10, 15, 19, 24][stringIndex]) / 12);
      const osc = audioContext.createOscillator();
      const gain = audioContext.createGain();
      osc.type = 'triangle';
      osc.frequency.value = freq;
      gain.gain.setValueAtTime(0.0001, audioContext.currentTime + offset);
      gain.gain.exponentialRampToValueAtTime(0.12, audioContext.currentTime + offset + 0.02);
      gain.gain.exponentialRampToValueAtTime(0.0001, audioContext.currentTime + offset + 1.4);
      osc.connect(gain).connect(audioContext.destination);
      osc.start(audioContext.currentTime + offset);
      osc.stop(audioContext.currentTime + offset + 1.5);
    });
  } catch (error) {
    console.warn('Audio no disponible', error);
  }
}

/** Tokens, dificultad y mocks de UI. */
function renderDesign() {
  $('[data-tokens]').innerHTML = TOKENS.map(
    (t) => '<li><span>' + t.name + '</span><span class="swatch" style="background:' +
      t.value + '"></span></li>'
  ).join('');
  $('[data-difficulty]').innerHTML = DIFFICULTY.map(
    (d) => '<li><span class="pill" style="--pill:var(--diff-' + d.level +
      ')">' + d.level + '</span>' + d.label + '</li>'
  ).join('');
  $('[data-mockups]').innerHTML =
    '<article class="mockup"><h4>Móvil · barra inferior</h4><div class="nav-demo">' +
    ['Inicio', 'Acordes', 'En vivo', 'Ajustes']
      .map((l, i) => '<span data-active="' + (i === 1) + '">' + l + '</span>')
      .join('') +
    '</div></article>' +
    '<article class="mockup"><h4>Escritorio · rail lateral</h4><div class="rail-demo">' +
    '<nav>' + [0, 1, 2, 3].map((i) =>
      '<span class="rail-item" data-active="' + (i === 1) + '">●</span>'
    ).join('') + '</nav><div class="rail-content">Grid de 4-5 columnas</div></div></article>' +
    '<article class="mockup"><h4>En vivo · afinador</h4><div class="live-demo">' +
    '<div class="live-note">A4</div><div class="meter"><i></i></div></div></article>';
}

/** App bar con elevación al hacer scroll. */
function bindAppBar() {
  const bar = $('.app-bar');
  const onScroll = () => {
    bar.dataset.elevated = String(window.scrollY > 8);
  };
  window.addEventListener('scroll', onScroll, { passive: true });
}

function renderLearn() {
  const host = $('[data-learn]');
  if (!host) return;
  host.innerHTML = LEARN_FEATURES.map(
    (f) => '<article class="feature"><span class="icon"><svg viewBox="0 0 24 24" width="22" height="22">' +
      ICONS[f.icon] + '</svg></span><h3>' + f.title + '</h3><p>' + f.text +
      '</p></article>'
  ).join('');
}

renderLearn();
renderFeatures();
renderHeroGrid();
renderLibrary();
renderDesign();
bindAppBar();
