/// Utilidades de clases de tono compartidas por el dominio.
library;

/// Nombres de las 12 clases de tono ordenados por índice.
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

/// Índice (0-11) de una nota por su nombre; -1 si no existe.
int pitchClassOfNote(String note) => kPitchClassNames.indexOf(note);

/// Nombre de nota para un índice de clase de tono.
String noteNameOfPitchClass(int pitchClass) =>
    kPitchClassNames[pitchClass % 12];
