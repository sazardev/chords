import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/services/chord_insights.dart';
import 'package:chords/presentation/features/chords/chord_detail_extras.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/real_bank.dart';

/// Filtro de posiciones de la ficha.
void main() {
  ChordDetailExtras extrasOf(String id) => ChordDetailExtras(
    realChord(id),
    ChordInsights.of(realChord(id), realBank()),
  );

  test('sin filtro se ven todas las posiciones', () {
    final ChordDetailExtras extras = extrasOf('C-7');
    expect(extras.filter, isNull);
    expect(extras.visibleIndices.length, extras.chord.variantCount);
  });

  test('solo se ofrecen las etiquetas que alguna posición tiene', () {
    final ChordDetailExtras extras = extrasOf('C-maj7');
    for (final String tag in extras.availableTags) {
      expect(
        extras.chord.variants.any((ChordVariant v) => v.tags.contains(tag)),
        isTrue,
        reason: tag,
      );
    }
    expect(extras.availableTags, contains('open'));
    expect(extras.availableTags, contains('drop2'));
    expect(extras.availableTags, contains('shell'));
    expect(extras.availableTags, isNot(contains('triad')));
  });

  test('filtrar deja las posiciones con la etiqueta y avisa', () {
    final ChordDetailExtras extras = extrasOf('C-maj');
    int notified = 0;
    extras
      ..addListener(() => notified++)
      ..setFilter('triad');
    expect(notified, 1);
    expect(extras.visibleIndices, isNotEmpty);
    for (final int i in extras.visibleIndices) {
      expect(extras.chord.variants[i].tags, contains('triad'));
    }
    extras.setFilter('triad');
    expect(notified, 1, reason: 'el mismo filtro no vuelve a avisar');
    extras.setFilter(null);
    expect(extras.visibleIndices.length, extras.chord.variantCount);
  });
}
