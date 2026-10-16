import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/usecases/build_minigame_use_cases.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';

import 'chord_bank.dart';
import 'fake_chord_repository.dart';

/// Los juegos de opciones con acordes.
const List<MiniGameKind> kChordQuizGames = <MiniGameKind>[
  MiniGameKind.spellChord,
  MiniGameKind.chordFormula,
  MiniGameKind.chordVariantEar,
  MiniGameKind.chordMemory,
  MiniGameKind.rootAndBass,
  MiniGameKind.inversion,
  MiniGameKind.wrongDiagram,
  MiniGameKind.cagedShape,
  MiniGameKind.rushOpen,
  MiniGameKind.rushBarre,
  MiniGameKind.rushSeventh,
  MiniGameKind.fillProgression,
  MiniGameKind.romanDegree,
  MiniGameKind.transposeChord,
  MiniGameKind.chordNeighbors,
  MiniGameKind.styleDuel,
];

/// Preguntas de los juegos con acordes sobre el banco real y una semilla fija.
class ChordGameSampler {
  /// Crea el muestreador con la semilla [seed].
  ChordGameSampler({int seed = 42}) : bank = loadChordBank() {
    quiz = BuildQuizUseCase(bank, random: math.Random(seed));
  }

  /// Banco real de acordes.
  final FakeChordRepository bank;

  /// Constructor de partidas.
  late final BuildQuizUseCase quiz;

  /// Todas las preguntas de [kind] en [level] sobre varias partidas.
  List<QuizQuestion> sample(MiniGameKind kind, MiniGameLevel level) =>
      <QuizQuestion>[
        for (int round = 0; round < 12; round++) ...quiz(kind, level),
      ];

  /// Cifra del acorde del banco con ese identificador.
  ChordSymbol symbolOf(String chordId) {
    final Chord chord = bank.chordById(chordId)!;
    return ChordSymbol(chord.root.pitchClass, chord.quality);
  }

  /// Acorde que muestra la pregunta.
  Chord chordOf(QuizQuestion q) => bank.chordById(q.chordId!)!;

  /// Cifra del acorde del banco con ese nombre (`Cmaj7`).
  ChordSymbol symbolByName(String name) {
    final Chord chord = bank.chords.firstWhere((Chord c) => c.name == name);
    return ChordSymbol(chord.root.pitchClass, chord.quality);
  }

  /// Clases de tono de una opción de conjunto de notas.
  List<int> tonesOf(QuizChoice choice) => <int>[
    for (final String pc in choice.value.split(',')) int.parse(pc),
  ];
}
