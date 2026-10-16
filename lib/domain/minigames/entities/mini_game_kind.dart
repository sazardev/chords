import 'package:chords/domain/minigames/entities/mini_game_level.dart';

/// Familia de un minijuego: cómo se juega.
enum MiniGameCategory {
  /// Solo escuchar y reconocer: no hace falta guitarra.
  ear,

  /// Mástil y dedos: reconocer o colocar sobre el diapasón.
  fretboard,

  /// Tocar la guitarra y que el micrófono lo compruebe.
  play,

  /// Teoría: escalas, tonalidades, grados y progresiones.
  theory,

  /// Acordes y sus variantes: notas, fórmulas, diagramas, formas y retos.
  chords,

  /// Progresiones y armonía: grados, transporte, relativos y estilos.
  harmony,
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
  echo(MiniGameCategory.play, rounds: 6),

  /// Decir qué nota pertenece a una escala.
  scaleNote(MiniGameCategory.theory),

  /// Decir qué acorde ocupa un grado de la tonalidad.
  keyChord(MiniGameCategory.theory),

  /// Decir qué grado ocupa una nota en la tonalidad.
  scaleDegree(MiniGameCategory.theory),

  /// Escuchar una cadencia y reconocer su tónica.
  findTonic(MiniGameCategory.theory, rounds: 8),

  /// Escuchar una progresión y decir cuál es.
  progressionEar(MiniGameCategory.theory, rounds: 8),

  /// Dado un acorde, decir qué notas lo forman (difícil: en orden).
  spellChord(MiniGameCategory.chords, isNew: true),

  /// Del acorde a su fórmula de intervalos y de la fórmula al acorde.
  chordFormula(MiniGameCategory.chords, isNew: true),

  /// Escuchar un acorde y decir qué variante es (7, maj7, 6, sus…).
  chordVariantEar(MiniGameCategory.chords, isNew: true),

  /// Repetir en orden una sucesión de acordes escuchada.
  chordMemory(MiniGameCategory.chords, rounds: 6, isNew: true),

  /// Leer un diagrama: qué cuerda lleva la raíz y qué nota está en el bajo.
  rootAndBass(MiniGameCategory.chords, isNew: true),

  /// Decir si una posición está en estado fundamental o invertida.
  inversion(MiniGameCategory.chords, isNew: true),

  /// Encontrar el diagrama con un error entre varios del mismo acorde.
  wrongDiagram(MiniGameCategory.chords, isNew: true),

  /// Reconocer la forma CAGED de un diagrama y dónde va la cejilla.
  cagedShape(MiniGameCategory.chords, isNew: true),

  /// Reto con tiempo: nombrar acordes abiertos.
  rushOpen(MiniGameCategory.chords, isNew: true, timed: true),

  /// Reto con tiempo: nombrar acordes con cejilla.
  rushBarre(MiniGameCategory.chords, isNew: true, timed: true),

  /// Reto con tiempo: nombrar séptimas y acordes extendidos.
  rushSeventh(MiniGameCategory.chords, isNew: true, timed: true),

  /// Completar el compás que falta de una progresión.
  fillProgression(MiniGameCategory.harmony, isNew: true),

  /// Pasar del grado romano al acorde y del acorde al grado.
  romanDegree(MiniGameCategory.harmony, isNew: true),

  /// Transponer un acorde: semitonos y capo.
  transposeChord(MiniGameCategory.harmony, isNew: true),

  /// Relativo, dominante, subdominante y círculo de quintas.
  chordNeighbors(MiniGameCategory.harmony, isNew: true),

  /// Reconocer el género por la progresión y el rasgueo que suenan.
  styleDuel(MiniGameCategory.harmony, rounds: 8, isNew: true),

  /// Cambios de acorde limpios con el micrófono, contra el reloj.
  chordChanges(MiniGameCategory.play, isNew: true);

  /// Crea un minijuego de una familia con su número de rondas.
  const MiniGameKind(
    this.category, {
    this.rounds = 10,
    this.isNew = false,
    this.timed = false,
  });

  /// Familia del juego.
  final MiniGameCategory category;

  /// Rondas de una partida.
  final int rounds;

  /// `true` si el catálogo lo marca como novedad.
  final bool isNew;

  /// `true` si cada pregunta se responde contra el reloj.
  final bool timed;

  /// Milisegundos para responder cada pregunta de un juego con tiempo.
  int timeLimitMs(MiniGameLevel level) => switch (level) {
    MiniGameLevel.easy => 15000,
    MiniGameLevel.medium => 10000,
    MiniGameLevel.hard => 6000,
  };

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
