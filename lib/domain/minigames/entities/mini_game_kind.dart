/// Familia de un minijuego: cómo se juega.
enum MiniGameCategory {
  /// Solo escuchar y reconocer: no hace falta guitarra.
  ear,

  /// Mástil y dedos: reconocer o colocar sobre el diapasón.
  fretboard,

  /// Tocar la guitarra y que el micrófono lo compruebe.
  play,
}

/// Minijuegos disponibles.
enum MiniGameKind {
  /// Escuchar una nota y decir cuál es.
  guessNote(MiniGameCategory.ear),

  /// Escuchar una cuerda al aire y decir cuál es.
  whichString(MiniGameCategory.ear),

  /// Escuchar una nota pulsada y decir en qué traste está.
  whichFret(MiniGameCategory.ear),

  /// Escuchar dos notas y decir qué intervalo forman.
  interval(MiniGameCategory.ear),

  /// Escuchar dos notas y decir cuál es más aguda.
  higherLower(MiniGameCategory.ear),

  /// Escuchar un acorde y decir si es mayor, menor, séptima…
  chordQuality(MiniGameCategory.ear),

  /// Escuchar un acorde y decir cómo se llama.
  nameChord(MiniGameCategory.ear),

  /// Comparar una nota con su referencia: ¿floja, afinada o alta?
  tuneEar(MiniGameCategory.ear),

  /// Repetir en orden una secuencia de cuerdas escuchada.
  memory(MiniGameCategory.ear, rounds: 6),

  /// Decir qué nota suena en una cuerda y traste.
  noteAtFret(MiniGameCategory.fretboard),

  /// Decir en qué traste de una cuerda está una nota.
  fretOfNote(MiniGameCategory.fretboard),

  /// Decir qué dedo pisa una cuerda de un acorde.
  fingerQuiz(MiniGameCategory.fretboard),

  /// Leer un diagrama y decir qué acorde es.
  readDiagram(MiniGameCategory.fretboard),

  /// Dado el nombre del acorde, colocar los dedos en el mástil.
  buildChord(MiniGameCategory.fretboard, rounds: 6),

  /// Tocar una nota pedida.
  playNote(MiniGameCategory.play, rounds: 6),

  /// Tocar una cuerda y un traste concretos.
  playStringFret(MiniGameCategory.play, rounds: 6),

  /// Escuchar una melodía corta y tocarla.
  echo(MiniGameCategory.play, rounds: 6);

  /// Crea un minijuego de una familia con su número de rondas.
  const MiniGameKind(this.category, {this.rounds = 10});

  /// Familia del juego.
  final MiniGameCategory category;

  /// Rondas de una partida.
  final int rounds;

  /// Identificador estable (rutas, preferencias y analítica).
  String get id => name;

  /// `true` si el juego escucha el micrófono.
  bool get usesMic => category == MiniGameCategory.play;

  /// Resuelve un juego por su identificador; `null` si no existe.
  static MiniGameKind? fromId(String? id) {
    for (final MiniGameKind kind in MiniGameKind.values) {
      if (kind.id == id) {
        return kind;
      }
    }
    return null;
  }

  /// Juegos de una familia, en orden de presentación.
  static List<MiniGameKind> of(MiniGameCategory category) => <MiniGameKind>[
    for (final MiniGameKind kind in MiniGameKind.values)
      if (kind.category == category) kind,
  ];
}
