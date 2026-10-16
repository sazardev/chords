import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/essential_chords.dart';

/// Orden con el que se presenta la lista de acordes.
enum ChordSort {
  /// Los esenciales primero y luego de lo más fácil y habitual a lo más raro.
  essentials,

  /// De lo más fácil a lo más difícil.
  difficulty,

  /// Por nota raíz (Do, Do#, Re…) y, dentro de ella, por tipo.
  root,

  /// Por tipo de acorde (mayor, menor, séptima…) y, dentro, por raíz.
  quality,
}

/// Raíces (clase de tono) de las más cómodas a las menos: las de los acordes
/// abiertos primero.
const List<int> kRootFriendliness = <int>[0, 7, 2, 9, 4, 5, 11, 10, 3, 8, 1, 6];

/// Ordena listas de acordes según un [ChordSort].
class ChordSorter {
  /// Crea el ordenador.
  const ChordSorter();

  /// Copia de [chords] ordenada por [mode] (el orden es estable y total).
  List<Chord> sort(List<Chord> chords, ChordSort mode) =>
      List<Chord>.of(chords)..sort(comparatorOf(mode));

  /// Como [sort], pero primero por [relevance] (0 la mejor): lo que más se
  /// parece a la búsqueda va delante y [mode] ordena dentro de cada grupo.
  List<Chord> sortRanked(
    List<Chord> chords,
    ChordSort mode,
    int Function(Chord chord) relevance,
  ) {
    final Comparator<Chord> inner = comparatorOf(mode);
    final Map<Chord, int> ranks = <Chord, int>{
      for (final Chord chord in chords) chord: relevance(chord),
    };
    return List<Chord>.of(chords)..sort((Chord a, Chord b) {
      final int byRank = ranks[a]!.compareTo(ranks[b]!);
      return byRank != 0 ? byRank : inner(a, b);
    });
  }

  /// Comparador de [mode].
  Comparator<Chord> comparatorOf(ChordSort mode) => switch (mode) {
    ChordSort.essentials => _essentials,
    ChordSort.difficulty => _difficulty,
    ChordSort.root => _byRoot,
    ChordSort.quality => _byQuality,
  };

  /// Orden de estudio de un grupo de acordes: los más fáciles primero y, para
  /// que la lista tenga variedad, alternando tipos de acorde (una séptima, un
  /// power chord, un mayor, un menor…) en lugar de agotar un tipo tras otro.
  ///
  /// Dentro de cada tipo van antes los de menor dificultad y las raíces
  /// cómodas (Do, Sol, Re, La, Mi…).
  List<Chord> learningOrder(List<Chord> chords) {
    final Map<ChordQuality, List<Chord>> byQuality =
        <ChordQuality, List<Chord>>{};
    for (final Chord chord in chords) {
      byQuality.putIfAbsent(chord.quality, () => <Chord>[]).add(chord);
    }
    final List<List<Chord>> buckets = <List<Chord>>[
      for (final ChordQuality quality
          in byQuality.keys.toList()..sort(_byLearningRank))
        byQuality[quality]!..sort(_easyThenFriendly),
    ];
    final List<Chord> result = <Chord>[];
    for (int round = 0; result.length < chords.length; round++) {
      for (final List<Chord> bucket in buckets) {
        if (round < bucket.length) {
          result.add(bucket[round]);
        }
      }
    }
    return result;
  }

  /// Tipos de acorde en el orden en que se enseñan: séptimas y power chords
  /// antes que las triadas, que ya se saben, y luego el orden del enum.
  static const List<ChordQuality> _firstQualities = <ChordQuality>[
    ChordQuality.seven,
    ChordQuality.power,
    ChordQuality.major,
    ChordQuality.minor,
  ];

  int _byLearningRank(ChordQuality a, ChordQuality b) =>
      _learningRank(a).compareTo(_learningRank(b));

  int _learningRank(ChordQuality quality) {
    final int first = _firstQualities.indexOf(quality);
    return first >= 0 ? first : _firstQualities.length + quality.index;
  }

  int _easyThenFriendly(Chord a, Chord b) => _chain(<int>[
    a.difficulty.level.compareTo(b.difficulty.level),
    _friendly(a).compareTo(_friendly(b)),
  ]);

  int _essentials(Chord a, Chord b) => _chain(<int>[
    _essentialRank(a).compareTo(_essentialRank(b)),
    a.difficulty.level.compareTo(b.difficulty.level),
    b.quality.popularity.compareTo(a.quality.popularity),
    a.quality.index.compareTo(b.quality.index),
    _friendly(a).compareTo(_friendly(b)),
  ]);

  int _difficulty(Chord a, Chord b) => _chain(<int>[
    a.difficulty.level.compareTo(b.difficulty.level),
    b.quality.popularity.compareTo(a.quality.popularity),
    a.quality.index.compareTo(b.quality.index),
    _friendly(a).compareTo(_friendly(b)),
  ]);

  int _byRoot(Chord a, Chord b) => _chain(<int>[
    a.root.pitchClass.compareTo(b.root.pitchClass),
    a.quality.index.compareTo(b.quality.index),
  ]);

  int _byQuality(Chord a, Chord b) => _chain(<int>[
    a.quality.index.compareTo(b.quality.index),
    a.root.pitchClass.compareTo(b.root.pitchClass),
  ]);

  /// Posición entre los esenciales; los demás van después, todos iguales.
  int _essentialRank(Chord chord) {
    final int index = kEssentialChordIds.indexOf(chord.id);
    return index < 0 ? kEssentialChordIds.length : index;
  }

  int _friendly(Chord chord) =>
      kRootFriendliness.indexOf(chord.root.pitchClass);

  int _chain(List<int> comparisons) {
    for (final int comparison in comparisons) {
      if (comparison != 0) {
        return comparison;
      }
    }
    return 0;
  }
}
