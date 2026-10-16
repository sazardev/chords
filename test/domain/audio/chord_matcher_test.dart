import 'dart:typed_data';

import 'package:chords/domain/audio/entities/chord_candidate.dart';
import 'package:chords/domain/audio/services/chord_matcher.dart';
import 'package:chords/domain/audio/services/chord_template.dart';
import 'package:chords/domain/audio/services/chord_template_bank.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:test/test.dart';

/// Cromagrama con [level] en las notas del acorde y [floor] en el resto.
Float64List _chroma(
  ChordRoot root,
  ChordQuality quality, {
  double level = 1,
  double floor = 0,
}) {
  final Float64List chroma = Float64List(12)..fillRange(0, 12, floor);
  for (final int interval in quality.intervals) {
    chroma[(root.pitchClass + interval) % 12] = level;
  }
  return chroma;
}

Float64List _only(Map<int, double> levels) {
  final Float64List chroma = Float64List(12);
  levels.forEach((int note, double level) => chroma[note] = level);
  return chroma;
}

/// Tests de las plantillas de acorde y del comparador.
void main() {
  group('ChordTemplateBank', () {
    test('tiene una plantilla por raíz y calidad del banco', () {
      final ChordTemplateBank bank = ChordTemplateBank();

      expect(bank.length, ChordRoot.values.length * ChordQuality.values.length);
      for (final ChordTemplate template in bank.templates) {
        final Set<int> expected = <int>{
          for (final int i in template.quality.intervals)
            (template.root.pitchClass + i) % 12,
        };
        expect(template.notes.toSet(), expected, reason: '${template.root}');
        expect(template.contains(template.rootPitchClass), isTrue);
      }
    });

    test('la quinta es opcional solo en acordes de cuatro notas o más', () {
      final ChordTemplate seventh = ChordTemplate(
        ChordRoot.c,
        ChordQuality.seven,
      );
      final ChordTemplate triad = ChordTemplate(
        ChordRoot.c,
        ChordQuality.major,
      );
      final ChordTemplate power = ChordTemplate(
        ChordRoot.c,
        ChordQuality.power,
      );

      expect(seventh.mandatory, isNot(contains(7)));
      expect(seventh.weights[7], lessThan(1));
      expect(triad.mandatory, contains(7));
      expect(power.mandatory, contains(7));
    });
  });

  group('ChordMatcher', () {
    final ChordMatcher matcher = ChordMatcher();

    test('reconoce cada raíz y calidad con el bajo en la raíz', () {
      for (final ChordQuality quality in ChordQuality.values) {
        for (final ChordRoot root in ChordRoot.values) {
          final List<ChordCandidate> ranked = matcher.rank(
            _chroma(root, quality, floor: 0.04),
            root.pitchClass,
          );

          expect(ranked.first.root, root, reason: '${root.name}${quality.id}');
          expect(
            ranked.first.quality,
            quality,
            reason: '${root.name}${quality.id}',
          );
        }
      }
    });

    test('sin bajo, el acorde equivalente (mismas notas) cuenta igual', () {
      for (final ChordQuality quality in ChordQuality.values) {
        final List<ChordCandidate> ranked = matcher.rank(
          _chroma(ChordRoot.d, quality),
          -1,
        );
        final Set<int> wanted = ChordCandidate(
          root: ChordRoot.d,
          quality: quality,
          score: 1,
          confidence: 1,
        ).pitchClasses;

        expect(ranked.first.pitchClasses, wanted, reason: quality.id);
      }
    });

    test('el bajo separa Am7 de C6, que tienen las mismas notas', () {
      final Float64List chroma = _chroma(ChordRoot.a, ChordQuality.minorSeven);

      final ChordCandidate withA = matcher.rank(chroma, 9).first;
      final ChordCandidate withC = matcher.rank(chroma, 0).first;

      expect(withA.id, 'A-m7');
      expect(withC.id, 'C-6');
    });

    test('una inversión no cambia el acorde', () {
      final Float64List chroma = _chroma(ChordRoot.c, ChordQuality.major);

      expect(matcher.rank(chroma, 4).first.id, 'C-maj');
      expect(matcher.rank(chroma, 7).first.id, 'C-maj');
    });

    test('Do mayor con séptima débil sigue siendo Do mayor', () {
      // La séptima suena en una sola cuerda, mucho más baja que la raíz doble.
      final Float64List chroma = _only(<int, double>{
        0: 1,
        4: 0.5,
        7: 0.8,
        11: 0.04,
      });

      expect(matcher.rank(chroma, 0).first.id, 'C-maj');
    });

    test('una nota suelta, con su quinta de armónico, no es muy segura', () {
      final Float64List chroma = _only(<int, double>{4: 1, 11: 0.3});

      final List<ChordCandidate> ranked = matcher.rank(chroma, 4);

      // Como mucho un power chord con el tope de confianza: nunca "muy seguro".
      expect(ranked.first.confidence, lessThan(0.75));
    });

    test('un power chord nunca pasa del tope de confianza', () {
      final List<ChordCandidate> ranked = matcher.rank(
        _chroma(ChordRoot.e, ChordQuality.power),
        4,
      );

      expect(ranked.first.id, 'E-5');
      expect(ranked.first.confidence, lessThanOrEqualTo(0.7));
      expect(ranked.first.confidence, greaterThan(0.5));
    });

    test('la confianza baja cuando dos acordes empatan', () {
      // Sin bajo, Do 6 y La m7 son indistinguibles.
      final List<ChordCandidate> ranked = matcher.rank(
        _chroma(ChordRoot.c, ChordQuality.sixth),
        -1,
      );

      expect(ranked.first.confidence, lessThan(0.8));
    });

    test('devuelve los candidatos ordenados y respeta el límite', () {
      final List<ChordCandidate> ranked = matcher.rank(
        _chroma(ChordRoot.g, ChordQuality.seven, floor: 0.05),
        7,
        limit: 4,
      );

      expect(ranked, hasLength(4));
      for (int i = 1; i < ranked.length; i++) {
        expect(ranked[i - 1].score, greaterThanOrEqualTo(ranked[i].score));
      }
    });

    test('sin energía no hay candidatos', () {
      expect(matcher.rank(Float64List(12), -1), isEmpty);
    });
  });
}
