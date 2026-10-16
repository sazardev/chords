import 'package:chords/domain/chords/entities/chord_quality.dart';

/// Qué nota del acorde suena en el bajo de una posición.
enum ChordInversion {
  /// La raíz: posición fundamental.
  root,

  /// La tercera.
  first,

  /// La quinta.
  second,

  /// La séptima (o la sexta en los acordes con sexta).
  third,

  /// Otra nota (novena, oncena, cuarta…).
  other,
}

/// Grado del acorde (`b3`, `5`, `9`…) que ocupa el intervalo [interval].
///
/// Devuelve `?` si el intervalo no pertenece a la calidad.
String degreeOf(ChordQuality quality, int interval) {
  for (int i = 0; i < quality.intervals.length; i++) {
    if (quality.intervals[i] % 12 == interval % 12) {
      return quality.formula[i];
    }
  }
  return '?';
}

/// Inversión que produce tener [bassInterval] semitonos sobre la raíz en el
/// bajo del acorde [quality].
ChordInversion inversionOf(ChordQuality quality, int bassInterval) {
  if (bassInterval % 12 == 0) {
    return ChordInversion.root;
  }
  return switch (degreeOf(quality, bassInterval)) {
    '3' || 'b3' => ChordInversion.first,
    '5' || 'b5' || '#5' => ChordInversion.second,
    '7' || 'b7' || 'bb7' || '6' => ChordInversion.third,
    _ => ChordInversion.other,
  };
}
