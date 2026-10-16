import 'dart:math' as math;

import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/minigames/entities/mini_game_kind.dart';
import 'package:chords/domain/minigames/entities/mini_game_level.dart';
import 'package:chords/domain/minigames/entities/quiz_question.dart';
import 'package:chords/domain/minigames/entities/sound_cue.dart';
import 'package:chords/domain/minigames/services/caged_shape.dart';
import 'package:chords/domain/minigames/services/chord_inversion.dart';
import 'package:chords/domain/minigames/services/strum_cues.dart';
import 'package:chords/domain/minigames/services/voicing_flaws.dart';
import 'package:chords/domain/minigames/usecases/build_minigame_use_cases.dart';
import 'package:chords/domain/theory/entities/chord_symbol.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/chord_bank.dart';
import '../../fakes/fake_chord_repository.dart';

/// Los juegos con acordes dependen del banco, no de cifras fijas: servicios
/// de diagramas y ritmo, y generación con un banco recortado.
void main() {
  final FakeChordRepository bank = loadChordBank();

  List<MiniGameKind> chordQuizKinds(BuildQuizUseCase quiz) => <MiniGameKind>[
    for (final MiniGameKind kind in MiniGameKind.values)
      if (kind.isNew && quiz.supports(kind)) kind,
  ];

  group('diagramas', () {
    test('todas las posiciones del banco son válidas como su acorde', () {
      for (final Chord chord in bank.chords) {
        for (final ChordVariant variant in chord.variants) {
          expect(
            isValidVoicing(chord, variant.frets),
            isTrue,
            reason: '${chord.id} ${variant.positionLabel}',
          );
        }
      }
    });

    test('estropear una posición siempre la deja inválida', () {
      final math.Random random = math.Random(2);
      int flawed = 0;
      for (final Chord chord in bank.chords) {
        for (final ChordVariant variant in chord.variants) {
          final FlawedVoicing? flaw = flawVoicing(random, chord, variant);
          if (flaw == null) {
            continue;
          }
          flawed++;
          expect(isValidVoicing(chord, flaw.frets), isFalse);
          expect(flaw.frets.length, 6);
          expect(flaw.frets, isNot(variant.frets));
        }
      }
      expect(flawed, greaterThan(bank.chords.length));
    });

    test('las inversiones salen del bajo de la posición', () {
      final Chord c = bank.chordById('C-maj')!;
      final Map<String, ChordInversion?> byLabel = <String, ChordInversion?>{
        for (final ChordVariant v in c.variants)
          v.positionLabel: inversionOf(c, v),
      };
      expect(byLabel['Forma de Do'], ChordInversion.root);
      expect(byLabel['Triada D-G-B · bajo en E'], ChordInversion.first);
      expect(byLabel['Triada G-B-e · bajo en G'], ChordInversion.second);
      expect(byLabel['Triada A-D-G · bajo en C'], ChordInversion.root);
    });

    test('las formas CAGED del banco se reconocen y encajan con su traste', () {
      final Set<CagedShape> seen = <CagedShape>{};
      for (final Chord chord in bank.chords) {
        for (final ChordVariant variant in chord.variants) {
          final CagedShape? shape = CagedShape.ofVariant(variant);
          if (shape == null) {
            continue;
          }
          seen.add(shape);
          // La raíz de la forma de Mi va en la 6ª cuerda y la de La en la 5ª.
          final int rootString = shape == CagedShape.e ? 0 : 1;
          final bool rootForm = shape == CagedShape.e || shape == CagedShape.a;
          if (rootForm && variant.frets[rootString] >= 0) {
            expect(
              variant.frets[rootString] % 12,
              shape.barreFretFor(chord.root.pitchClass),
              reason: '${chord.id} ${variant.positionLabel}',
            );
          }
        }
      }
      expect(seen, CagedShape.values.toSet());
    });
  });

  group('rasgueo', () {
    final ChordSymbol g = ChordSymbol.parse('G');

    test('cada golpe es un sonido y las pausas respetan el ritmo', () {
      final List<SoundCue> cues = strumCues(
        bank,
        <ChordSymbol>[g],
        StrumPattern.quarters,
        120,
      );
      expect(cues.length, 4);
      expect(cues.first.delayMs, 0);
      expect(cues.skip(1).map((SoundCue c) => c.delayMs), everyElement(500));
      expect(cues.every((SoundCue c) => c is ChordCue), isTrue);
    });

    test('el bajo del boom-chick es una nota grave, no un acorde', () {
      final List<SoundCue> cues = strumCues(
        bank,
        <ChordSymbol>[g],
        StrumPattern.boomChick,
        100,
      );
      expect(cues.length, 4);
      expect(cues[0], isA<ToneCue>());
      expect(cues[1], isA<ChordCue>());
      expect(cues[2], isA<ToneCue>());
      expect(cues[1].delayMs, 600);
    });

    test('los compases se enlazan sin perder el pulso', () {
      final List<SoundCue> cues = strumCues(
        bank,
        <ChordSymbol>[g, ChordSymbol.parse('C')],
        StrumPattern.whole,
        120,
      );
      expect(cues.length, 2);
      expect(cues.last.delayMs, 8 * 250, reason: 'un compás de 8 corcheas');
    });

    test('el silencio del reggae deja los tiempos fuertes vacíos', () {
      final List<SoundCue> cues = strumCues(
        bank,
        <ChordSymbol>[g],
        StrumPattern.skank,
        120,
      );
      expect(cues.length, hitsPerBar(StrumPattern.skank));
      expect(cues.last.delayMs, 4 * 250);
    });

    test('un acorde que no está en el banco se salta', () {
      final FakeChordRepository empty = FakeChordRepository(<Chord>[]);
      expect(
        strumCues(empty, <ChordSymbol>[g], StrumPattern.pop, 100),
        isEmpty,
      );
    });
  });

  group('con un banco recortado', () {
    test('los juegos se adaptan a las calidades y posiciones que haya', () {
      final List<ChordQuality> kept = <ChordQuality>[
        ChordQuality.major,
        ChordQuality.minor,
        ChordQuality.seven,
        ChordQuality.minorSeven,
        ChordQuality.majorSeven,
      ];
      final FakeChordRepository small = FakeChordRepository(<Chord>[
        for (final Chord chord in bank.chords)
          if (kept.contains(chord.quality)) chord,
      ]);
      final BuildQuizUseCase quiz = BuildQuizUseCase(
        small,
        random: math.Random(8),
      );
      for (final MiniGameKind kind in chordQuizKinds(quiz)) {
        for (final MiniGameLevel level in MiniGameLevel.values) {
          for (final QuizQuestion q in quiz(kind, level)) {
            expect(q.choices.toSet().length, q.choices.length, reason: kind.id);
            expect(q.choices.length, greaterThanOrEqualTo(2), reason: kind.id);
            final String? id = q.chordId;
            if (id != null) {
              expect(small.chordById(id), isNotNull, reason: kind.id);
            }
          }
        }
      }
    });

    test('las calidades que se estudian salen del banco, no de una lista', () {
      for (final Chord chord in bank.chords) {
        expect(ChordQuality.values, contains(chord.quality));
      }
      final Set<ChordQuality> used = <ChordQuality>{
        for (final Chord chord in bank.chords) chord.quality,
      };
      final BuildQuizUseCase quiz = BuildQuizUseCase(
        bank,
        random: math.Random(1),
      );
      final Set<String> seen = <String>{
        for (int round = 0; round < 30; round++)
          for (final QuizQuestion q in quiz(
            MiniGameKind.chordFormula,
            MiniGameLevel.hard,
          ))
            if (q.detail == 'toName') ...<String>[
              for (final QuizChoice c in q.choices) c.value.split('-').last,
            ],
      };
      expect(seen, used.map((ChordQuality q) => q.id).toSet());
    });
  });
}
