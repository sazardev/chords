import 'dart:math' as math;

import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/minigames/generators/ear_progression_pool.dart';
import 'package:chords/domain/minigames/generators/theory_ear_generators.dart';
import 'package:chords/domain/minigames/generators/theory_quiz_generators.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/musical_key.dart';
import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/chord_bank.dart';
import '../../fakes/fake_chord_repository.dart';

/// Los juegos de teoría siempre tienen una única respuesta correcta.
void main() {
  final FakeChordRepository bank = loadChordBank();
  final math.Random random = math.Random(7);

  void forEachQuestion(
    MiniGameKind kind,
    QuizQuestion Function(MiniGameLevel level) generate,
    void Function(QuizQuestion q) check,
  ) {
    for (final MiniGameLevel level in MiniGameLevel.values) {
      for (int i = 0; i < 40; i++) {
        final QuizQuestion q = generate(level);
        expect(q.kind, kind);
        expect(q.choices.toSet().length, q.choices.length, reason: 'repetidas');
        check(q);
      }
    }
  }

  test('nota de la escala: solo la correcta pertenece a la escala', () {
    const ScaleNoteGenerator generator = ScaleNoteGenerator();
    forEachQuestion(
      MiniGameKind.scaleNote,
      (MiniGameLevel l) => generator.generate(random, l, 0),
      (QuizQuestion q) {
        final ScaleType scale = ScaleType.fromId(q.scaleId)!;
        final List<bool> inside = <bool>[
          for (final QuizChoice c in q.choices)
            scale.contains(q.keyTonic!, kPitch(c.value)),
        ];
        expect(inside.where((bool b) => b).length, 1);
        expect(inside[q.answer.single], isTrue);
      },
    );
  });

  test('acorde del grado: la respuesta es el acorde de ese grado', () {
    const KeyChordGenerator generator = KeyChordGenerator();
    forEachQuestion(
      MiniGameKind.keyChord,
      (MiniGameLevel l) => generator.generate(random, l, 0),
      (QuizQuestion q) {
        final MusicalKey key = MusicalKey(
          q.keyTonic!,
          minor: q.scaleId == ScaleType.naturalMinor.id,
        );
        expect(
          q.correctChoice.value,
          key.harmony()[q.degree! - 1].symbol.chordId,
        );
        expect(bank.chordById(q.correctChoice.value), isNotNull);
      },
    );
  });

  test('qué grado es: la nota ocupa el grado de la respuesta', () {
    const ScaleDegreeGenerator generator = ScaleDegreeGenerator();
    forEachQuestion(
      MiniGameKind.scaleDegree,
      (MiniGameLevel l) => generator.generate(random, l, 0),
      (QuizQuestion q) {
        final MusicalKey key = MusicalKey(
          q.keyTonic!,
          minor: q.scaleId == ScaleType.naturalMinor.id,
        );
        final int degree = int.parse(q.correctChoice.value);
        expect(key.pitchClasses[degree - 1], kPitch(q.note!));
      },
    );
  });

  test('encuentra la tónica: suena una cadencia que termina en ella', () {
    final FindTonicGenerator generator = FindTonicGenerator(bank);
    forEachQuestion(
      MiniGameKind.findTonic,
      (MiniGameLevel l) => generator.generate(random, l, 0),
      (QuizQuestion q) {
        expect(q.cues.length, 4);
        final ChordCue last = q.cues.last as ChordCue;
        expect(bank.chordById(last.chordId), isNotNull);
        expect(
          ChordSymbol.parse(last.chordId.split('-').first).root,
          kPitch(q.correctChoice.value),
        );
      },
    );
  });

  test('progresión al oído: suenan los acordes de la respuesta', () {
    final ProgressionEarGenerator generator = ProgressionEarGenerator(bank);
    forEachQuestion(
      MiniGameKind.progressionEar,
      (MiniGameLevel l) => generator.generate(random, l, 0),
      (QuizQuestion q) {
        expect(q.cues.length, q.correctChoice.value.split(' ').length);
        expect(<String>[
          ...kEarProgressions,
          ...catalogEarProgressions(),
        ], contains(q.correctChoice.value));
        for (final SoundCue cue in q.cues) {
          expect(bank.chordById((cue as ChordCue).chordId), isNotNull);
        }
      },
    );
  });
}

/// Clase de tono de un nombre de nota inglés (`F#`).
int kPitch(String note) => ChordSymbol.parse(note).root;
