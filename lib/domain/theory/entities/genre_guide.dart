import 'package:chords/domain/theory/entities/scale_type.dart';
import 'package:chords/domain/theory/entities/strum_pattern.dart';
import 'package:meta/meta.dart';

/// Familia de estilos con la que se agrupa la guía de géneros.
enum GenreFamily {
  /// Raíces, música tradicional y ritmos latinos.
  roots,

  /// Rock, punk, metal y derivados.
  rock,

  /// Blues, jazz, soul, funk y gospel.
  soulJazz,

  /// Pop, balada y estilos de baile o electrónicos.
  pop,
}

/// Lo esencial de un género para tocarlo: tempo, ritmo, escalas y acordes.
///
/// Los textos (qué lo caracteriza, cómo se rasguea, un consejo) viven en las
/// traducciones bajo `theory.genres.<id>`.
@immutable
class GenreGuide {
  /// Crea la guía.
  const GenreGuide({
    required this.id,
    required this.family,
    required this.emoji,
    required this.minBpm,
    required this.maxBpm,
    required this.strum,
    required this.scales,
    required this.chords,
    this.libraryGenre,
  });

  /// Identificador estable (`country`).
  final String id;

  /// Familia en la que se agrupa en la guía.
  final GenreFamily family;

  /// Emoji que lo representa.
  final String emoji;

  /// Tempo habitual mínimo.
  final int minBpm;

  /// Tempo habitual máximo.
  final int maxBpm;

  /// Rasgueo característico.
  final StrumPattern strum;

  /// Escalas para improvisar o hacer riffs.
  final List<ScaleType> scales;

  /// Acordes que lo definen, como cifras de ejemplo (`E7`, `A9`).
  final List<String> chords;

  /// Género equivalente en la biblioteca de acordes (`Country`), si lo hay.
  final String? libraryGenre;
}
