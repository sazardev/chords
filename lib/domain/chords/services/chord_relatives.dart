import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';

/// Acordes parientes de otro: los que comparten raíz con otro color, y la
/// relativa menor o mayor.
class ChordRelatives {
  /// Crea el buscador de parientes sobre el banco [chords].
  ChordRelatives(Iterable<Chord> chords)
    : _byId = <String, Chord>{for (final Chord c in chords) c.id: c};

  final Map<String, Chord> _byId;

  /// Mismos nombre de raíz con otros tipos, los más usados primero.
  ///
  /// Con [limit] se queda con los [limit] primeros; el propio acorde no sale.
  List<Chord> sameRoot(Chord chord, {int limit = 12}) {
    final List<ChordQuality> qualities =
        ChordQuality.values
            .where((ChordQuality q) => q != chord.quality)
            .toList()
          ..sort(_byUse);
    return <Chord>[
      for (final ChordQuality quality in qualities)
        ?_byId['${chord.root.name}-${quality.id}'],
    ].take(limit).toList();
  }

  /// Relativa menor de un mayor (Do → La menor) o mayor de un menor
  /// (La menor → Do); `null` para el resto de calidades.
  Chord? relative(Chord chord) {
    final (int, ChordQuality)? target = switch (chord.quality) {
      ChordQuality.major => (9, ChordQuality.minor),
      ChordQuality.minor => (3, ChordQuality.major),
      _ => null,
    };
    if (target == null) {
      return null;
    }
    final ChordRoot root =
        ChordRoot.values[(chord.root.pitchClass + target.$1) % 12];
    return _byId['${root.name}-${target.$2.id}'];
  }

  static int _byUse(ChordQuality a, ChordQuality b) {
    final int byPopularity = b.popularity.compareTo(a.popularity);
    return byPopularity != 0 ? byPopularity : a.index.compareTo(b.index);
  }
}
