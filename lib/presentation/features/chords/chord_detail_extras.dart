import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/services/chord_insights.dart';
import 'package:flutter/foundation.dart';

/// Etiquetas por las que se pueden filtrar las posiciones, en el orden en
/// que se ofrecen.
const List<String> kVariantFilterTags = <String>[
  'open',
  'barre',
  'movable',
  'inversion',
  'triad',
  'shell',
  'drop2',
  'drop3',
  'upper',
];

/// Lo que la ficha enseña de un acorde además de su posición elegida: las
/// notas, los parientes, las tonalidades, las progresiones, las escalas y el
/// filtro de posiciones.
class ChordDetailExtras extends ChangeNotifier {
  /// Crea los extras de [chord] con su información [insights].
  ChordDetailExtras(this.chord, this.insights);

  /// Acorde mostrado.
  final Chord chord;

  /// Notas, parientes, tonalidades, progresiones y escalas.
  final ChordInsights insights;

  String? _filter;

  /// Etiqueta (`open`, `barre`, `drop2`…) por la que se filtran las
  /// posiciones; `null` las muestra todas.
  String? get filter => _filter;

  /// Filtra las posiciones por una etiqueta (`null` quita el filtro).
  void setFilter(String? tag) {
    if (tag == _filter) {
      return;
    }
    _filter = tag;
    notifyListeners();
  }

  /// Etiquetas que tiene al menos una posición del acorde, en un orden fijo.
  List<String> get availableTags {
    final Set<String> present = <String>{
      for (final ChordVariant v in chord.variants) ...v.tags,
    };
    return <String>[
      for (final String tag in kVariantFilterTags)
        if (present.contains(tag)) tag,
    ];
  }

  /// Índices de las posiciones que cumplen el filtro actual.
  List<int> get visibleIndices => <int>[
    for (final (int i, ChordVariant v) in chord.variants.indexed)
      if (_filter == null || v.tags.contains(_filter)) i,
  ];
}
