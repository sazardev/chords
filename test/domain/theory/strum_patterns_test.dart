import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:chords/l10n/translations.g.dart';
import 'package:flutter_test/flutter_test.dart';

/// Los patrones de rasgueo están bien formados, son distintos y se explican.
void main() {
  test('hay una colección amplia de patrones', () {
    expect(StrumPattern.values.length, greaterThanOrEqualTo(30));
    for (final String name in <String>[
      'cumbia',
      'salsa',
      'reggaeton',
      'rumba',
      'ska',
      'disco',
      'bolero',
      'tango',
      'valsRanchero',
      'valsCriollo',
      'merengue',
      'bachata',
      'campfire',
      'funkMuted',
      'arpeggio',
    ]) {
      expect(StrumPattern.fromName(name), isNotNull, reason: name);
    }
  });

  test('la notación mide 8 huecos (4/4) o 6 (3/4) y solo usa DUBX-', () {
    for (final StrumPattern p in StrumPattern.values) {
      expect(<int>[6, 8], contains(p.notation.length), reason: p.name);
      expect(RegExp(r'^[DUBX-]+$').hasMatch(p.notation), isTrue);
      expect(p.notation.replaceAll('-', ''), isNotEmpty, reason: p.name);
      expect(p.strokes.length, p.notation.length);
      expect(p.beatsPerBar, p.notation.length ~/ 2);
    }
  });

  test('no hay dos patrones con la misma notación', () {
    final Set<String> seen = <String>{};
    for (final StrumPattern p in StrumPattern.values) {
      expect(seen.add(p.notation), isTrue, reason: '${p.name} repetido');
    }
  });

  test('los vals están en 3/4 y el resto en 4/4', () {
    const Set<StrumPattern> waltzes = <StrumPattern>{
      StrumPattern.waltz,
      StrumPattern.valsRanchero,
      StrumPattern.valsCriollo,
    };
    for (final StrumPattern p in StrumPattern.values) {
      expect(p.beatsPerBar, waltzes.contains(p) ? 3 : 4, reason: p.name);
    }
  });

  test(
    'el golpe muteado suena como silencio pero se distingue con isMuted',
    () {
      expect(StrumPattern.rumba.hasMutedStrokes, isTrue);
      expect(StrumPattern.rumba.isMuted(4), isTrue);
      expect(StrumPattern.rumba.strokes[4], StrumStroke.rest);
      expect(StrumPattern.pop.hasMutedStrokes, isFalse);
      for (final StrumPattern p in StrumPattern.values) {
        for (int i = 0; i < p.notation.length; i++) {
          if (p.isMuted(i)) {
            expect(p.strokes[i], StrumStroke.rest);
          }
        }
      }
    },
  );

  test('cada símbolo se traduce a su golpe', () {
    final List<StrumStroke> strokes = StrumPattern.salsa.strokes;
    expect(strokes.first, StrumStroke.down);
    expect(StrumPattern.ska.strokes[1], StrumStroke.up);
    expect(StrumPattern.cumbia.strokes.first, StrumStroke.bass);
    expect(StrumPattern.ska.strokes.first, StrumStroke.rest);
  });

  for (final AppLocale locale in AppLocale.values) {
    test('${locale.languageCode}: cada patrón tiene nombre y descripción', () {
      final Translations t = locale.buildSync();
      for (final StrumPattern p in StrumPattern.values) {
        expect(t.theory.strumNames[p.name], isNotEmpty, reason: p.name);
        expect(t.theory.strumAbout[p.name], isNotEmpty, reason: p.name);
      }
    });
  }
}
