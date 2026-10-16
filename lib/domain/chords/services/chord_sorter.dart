import 'package:chords/domain/chords/entities/chord.dart';
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

  /// Orden de estudio: más fácil primero, calidades en orden pedagógico y
  /// raíces cómodas antes (lo usa el itinerario de aprendizaje).
  int learning(Chord a, Chord b) => _chain(<int>[
    a.difficulty.level.compareTo(b.difficulty.level),
    a.quality.index.compareTo(b.quality.index),
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
