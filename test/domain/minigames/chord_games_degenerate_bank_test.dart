import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/usecases/build_minigame_use_cases.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/chord_bank.dart';
import '../../fakes/fake_chord_repository.dart';

/// Los generadores filtran con seguridad: con bancos muy pobres (un solo
/// acorde, solo power chords, solo voicings buscados) nunca fallan por pedir
/// un elemento a una lista vacía; o generan la pregunta o lo dicen con un
/// `StateError` claro.
void main() {
  final FakeChordRepository full = loadChordBank();

  Chord only(Chord chord, bool Function(ChordVariant v) keep) => Chord(
    id: chord.id,
    root: chord.root,
    quality: chord.quality,
    variants: chord.variants.where(keep).toList(),
    tags: chord.tags,
  );

  final Map<String, FakeChordRepository> banks = <String, FakeChordRepository>{
    'un solo acorde': FakeChordRepository(<Chord>[full.chordById('C-maj')!]),
    'solo power chords': FakeChordRepository(<Chord>[
      for (final Chord c in full.chords)
        if (c.quality == ChordQuality.power) c,
    ]),
    'solo voicings buscados': FakeChordRepository(<Chord>[
      for (final Chord c in full.chords)
        if (c.variants.any((ChordVariant v) => !v.isShape))
          only(c, (ChordVariant v) => !v.isShape),
    ]),
    'solo formas': FakeChordRepository(<Chord>[
      for (final Chord c in full.chords) only(c, (ChordVariant v) => v.isShape),
    ]),
  };

  for (final MapEntry<String, FakeChordRepository> entry in banks.entries) {
    test('con ${entry.key} no se pide un elemento a una lista vacía', () {
      for (int seed = 0; seed < 5; seed++) {
        _check(entry.value, seed);
      }
    });
  }
}

void _check(FakeChordRepository bank, int seed) {
  final BuildQuizUseCase quiz = BuildQuizUseCase(
    bank,
    random: math.Random(seed),
  );
  for (final MiniGameKind kind in MiniGameKind.values) {
    if (!kind.isNew || !quiz.supports(kind)) {
      continue;
    }
    for (final MiniGameLevel level in MiniGameLevel.values) {
      // O genera preguntas bien formadas o lo dice con un StateError.
      try {
        for (final QuizQuestion q in quiz(kind, level)) {
          expect(
            q.choices.toSet().length,
            q.choices.length,
            reason: '${kind.id} ${level.id}',
          );
        }
      } on Object catch (error, stack) {
        expect(error, isA<StateError>(), reason: '${kind.id}\n$stack');
      }
    }
  }
}
