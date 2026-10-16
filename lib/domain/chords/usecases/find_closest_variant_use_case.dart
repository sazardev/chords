import 'package:chords/domain/chords/entities/chord.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';

/// Caso de uso: la posición de un acorde que más se parece a lo que suena.
///
/// Un mismo acorde se toca de varias formas, y el bajo es lo que más se oye de
/// la diferencia: si se conoce la nota más grave que suena, se elige la
/// posición cuya cuerda más grave pulsada da esa nota (la más fácil entre
/// ellas); si ninguna coincide o no se conoce el bajo, la más fácil.
class FindClosestVariantUseCase {
  /// Crea el caso de uso.
  const FindClosestVariantUseCase();

  /// Notas MIDI de las cuerdas al aire, de la sexta a la primera.
  static const List<int> _openStrings = <int>[40, 45, 50, 55, 59, 64];

  /// Posición de [chord] más cercana al [bass] (clase de nota 0-11) dado.
  ChordVariant call(Chord chord, {int? bass}) {
    final ChordVariant easiest = chord.easiestVariant;
    if (bass == null) {
      return easiest;
    }
    ChordVariant? best;
    for (final ChordVariant variant in chord.variants) {
      if (bassOf(variant) != bass) {
        continue;
      }
      if (best == null || variant.difficulty.level < best.difficulty.level) {
        best = variant;
      }
    }
    return best ?? easiest;
  }

  /// Clase de nota (0-11) de la cuerda más grave que suena en [variant];
  /// `null` si no suena ninguna.
  int? bassOf(ChordVariant variant) {
    for (int s = 0; s < variant.frets.length && s < _openStrings.length; s++) {
      if (variant.frets[s] >= 0) {
        return (_openStrings[s] + variant.frets[s]) % 12;
      }
    }
    return null;
  }
}
