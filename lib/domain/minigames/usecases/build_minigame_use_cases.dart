import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/repositories/chord_repository.dart';
import 'package:chords/domain/minigames/entities/chord_round.dart';
import 'package:chords/domain/minigames/entities/mic_challenge.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/generators/chord_quiz_generators.dart';
import 'package:chords/domain/minigames/generators/mic_challenge_generators.dart';
import 'package:chords/domain/minigames/generators/quiz_generator.dart';
import 'package:chords/domain/minigames/generators/quiz_generator_registry.dart';

/// Caso de uso: construye las preguntas de un minijuego de opciones.
class BuildQuizUseCase {
  /// Crea el caso de uso; [random] permite fijar la semilla en las pruebas.
  BuildQuizUseCase(ChordRepository repository, {math.Random? random})
    : _random = random ?? math.Random(),
      _generators = buildQuizGenerators(repository);

  final math.Random _random;
  final Map<MiniGameKind, QuizGenerator> _generators;

  /// `true` si [kind] se juega con preguntas de opciones.
  bool supports(MiniGameKind kind) => _generators.containsKey(kind);

  /// Construye las preguntas de una partida, sin repetir dos seguidas.
  List<QuizQuestion> call(MiniGameKind kind, MiniGameLevel level) {
    final QuizGenerator generator = _generators[kind]!;
    final List<QuizQuestion> questions = <QuizQuestion>[];
    for (int i = 0; i < kind.rounds; i++) {
      QuizQuestion question = generator.generate(_random, level, i);
      for (int tries = 0; tries < 6; tries++) {
        if (questions.isEmpty ||
            questions.last.signature != question.signature) {
          break;
        }
        question = generator.generate(_random, level, i);
      }
      questions.add(question);
    }
    return questions;
  }
}

/// Caso de uso: construye los retos de un juego de micrófono.
class BuildMicChallengesUseCase {
  /// Crea el caso de uso; [random] permite fijar la semilla en las pruebas.
  BuildMicChallengesUseCase({math.Random? random})
    : _random = random ?? math.Random();

  final math.Random _random;

  static const Map<MiniGameKind, MicChallengeGenerator> _generators =
      <MiniGameKind, MicChallengeGenerator>{
        MiniGameKind.playNote: PlayNoteGenerator(),
        MiniGameKind.playStringFret: PlayStringFretGenerator(),
        MiniGameKind.echo: EchoGenerator(),
      };

  /// `true` si [kind] se juega con el micrófono.
  bool supports(MiniGameKind kind) => _generators.containsKey(kind);

  /// Construye los retos de una partida.
  List<MicChallenge> call(MiniGameKind kind, MiniGameLevel level) {
    final MicChallengeGenerator generator = _generators[kind]!;
    return <MicChallenge>[
      for (int i = 0; i < kind.rounds; i++)
        generator.generate(_random, level, i),
    ];
  }
}

/// Caso de uso: elige los acordes de "arma el acorde".
///
/// Solo usa posiciones que caben en el tablero de cinco trastes y las
/// ordena al azar sin repetir acorde.
class BuildChordRoundsUseCase {
  /// Crea el caso de uso; [random] permite fijar la semilla en las pruebas.
  BuildChordRoundsUseCase(this._repository, {math.Random? random})
    : _random = random ?? math.Random();

  final ChordRepository _repository;
  final math.Random _random;

  /// Construye las rondas de una partida.
  List<ChordRound> call(MiniGameLevel level) {
    final List<Chord> pool =
        chordPoolFor(
            _repository,
            level,
          ).where((Chord chord) => _fitsBoard(chord.easiestVariant)).toList()
          ..shuffle(_random);
    final List<Chord> source = pool.isEmpty ? _repository.chords : pool;
    return <ChordRound>[
      for (int i = 0; i < MiniGameKind.buildChord.rounds; i++)
        _roundOf(source[i % source.length]),
    ];
  }

  ChordRound _roundOf(Chord chord) =>
      ChordRound(chordId: chord.id, variantIndex: easiestVariantIndex(chord));

  bool _fitsBoard(ChordVariant variant) =>
      variant.frets.every((int fret) => fret <= kBuildFrets);
}
