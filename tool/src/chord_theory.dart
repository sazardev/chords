/// Utilidades de teoría musical para Chords.
///
/// Centraliza las matemáticas de notas, clases de tono (pitch class) y la
/// afinación estándar de guitararra para que el generador, el validador y la
/// capa de dominio compartan una única fuente de verdad.
library;

/// Nombres de las 12 clases de tono.
const List<String> kPitchClassNames = <String>[
  'C',
  'C#',
  'D',
  'D#',
  'E',
  'F',
  'F#',
  'G',
  'G#',
  'A',
  'A#',
  'B',
];

/// Nombres en español (solfeo) de las 12 clases de tono.
const List<String> kPitchClassDisplayNames = <String>[
  'Do',
  'Do#',
  'Re',
  'Re#',
  'Mi',
  'Fa',
  'Fa#',
  'Sol',
  'Sol#',
  'La',
  'La#',
  'Si',
];

/// Afinación estándar de guitararra E2 A2 D3 G3 B3 E4 en valores MIDI.
const List<int> kStringTuning = <int>[40, 45, 50, 55, 59, 64];

/// Número de cuerdas de una guitararra estándar.
const int kStringCount = 6;

/// Índice de cuerda más grave (sexta cuerda).
const int kLowEIndex = 0;

/// Devuelve el índice de clase de tono (0-11) para un nombre de nota.
///
/// Lanza [ArgumentError] si la nota no existe.
int pitchClassOf(String note) {
  final int index = kPitchClassNames.indexOf(note);
  if (index < 0) {
    throw ArgumentError.value(note, 'note', 'Nota no reconocida');
  }
  return index;
}

/// Normaliza nombres enarmónicos (Db -> C#, Bb -> A#, ...).
String normalizeNoteName(String note) {
  const Map<String, String> enharmonic = <String, String>{
    'Db': 'C#',
    'Eb': 'D#',
    'Gb': 'F#',
    'Ab': 'G#',
    'Bb': 'A#',
  };
  return enharmonic[note] ?? note;
}

/// Nombre de nota para una clase de tono (0-11).
String noteNameOfPitchClass(int pitchClass) =>
    kPitchClassNames[pitchClass % 12];

/// Nombre en español para una clase de tono (0-11).
String displayNameOfPitchClass(int pitchClass) =>
    kPitchClassDisplayNames[pitchClass % 12];

/// Distancia en semitonos entre dos notas (0-11 hacia adelante).
int semitonesBetween(String from, String to) {
  final int delta = pitchClassOf(to) - pitchClassOf(from);
  return delta < 0 ? delta + 12 : delta;
}

/// Clases de tono de una calidad de acorde a partir de sus intervalos.
Set<int> pitchClassesForIntervals(int root, List<int> intervals) =>
    intervals.map((int i) => (root + i) % 12).toSet();

/// Notas (nombres) distintas que suenan en una posición de diapasón.
///
/// [frets] contiene 6 valores posicionales: `-1` cuerda muda, `0` al aire y
/// `n` traste pulsado.
List<String> notesForFrets(List<int> frets) {
  final Set<int> classes = <int>{};
  for (int s = 0; s < frets.length && s < kStringCount; s++) {
    final int fret = frets[s];
    if (fret < 0) {
      continue;
    }
    classes.add((kStringTuning[s] + fret) % 12);
  }
  return classes.map(noteNameOfPitchClass).toList()..sort();
}

/// Traste (0-12) donde una cuerda suena una nota objetivo, o `null` si no
/// existe dentro del rango razonable de un mástil.
int? fretForNoteOnString(int stringIndex, String targetNote) {
  final int openClass = kStringTuning[stringIndex] % 12;
  final int step = semitonesBetween(
    noteNameOfPitchClass(openClass),
    targetNote,
  );
  return step <= 12 ? step : null;
}
