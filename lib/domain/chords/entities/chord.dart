import 'package:chords/domain/chords/entities/chord_quality.dart';
import 'package:chords/domain/chords/entities/chord_root.dart';
import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/difficulty.dart';
import 'package:meta/meta.dart';

/// Acorde completo: una raíz, una calidad y todas sus posiciones.
@immutable
class Chord {
  /// Crea un acorde.
  const Chord({
    required this.id,
    required this.root,
    required this.quality,
    required this.variants,
    this.aliases = const <String>[],
    this.tags = const <String>[],
  });

  /// Identificador estable del acorde (p. ej. `C-maj`).
  final String id;

  /// Raíz del acorde.
  final ChordRoot root;

  /// Calidad del acorde.
  final ChordQuality quality;

  /// Posiciones disponibles ordenadas de más fácil a más difícil.
  final List<ChordVariant> variants;

  /// Nombres alternativos buscables.
  final List<String> aliases;

  /// Etiquetas agregadas del acorde.
  final List<String> tags;

  /// Nombre estándar del acorde (p. ej. `Cm7`).
  String get name => '${root.name}${quality.suffix}';

  /// Nombre en español (p. ej. `Do Séptima menor`).
  String get displayName => '${root.displayName} ${quality.label}';

  /// Nivel de dificultad del acorde: el de su forma más fácil.
  ///
  /// Cuentan las formas del catálogo (las de siempre); los voicings sueltos
  /// (tríadas, shells, drops) solo si el acorde no tiene ninguna forma.
  Difficulty get difficulty => _easiestOf(
    variants.where((ChordVariant v) => v.isShape),
    fallback: variants,
  );

  /// Posición recomendada: la primera (están de más fácil a más difícil).
  ChordVariant get easiestVariant => variants.first;

  static Difficulty _easiestOf(
    Iterable<ChordVariant> preferred, {
    required Iterable<ChordVariant> fallback,
  }) => (preferred.isEmpty ? fallback : preferred)
      .map((ChordVariant v) => v.difficulty)
      .reduce((Difficulty a, Difficulty b) => a.level <= b.level ? a : b);

  /// Número de posiciones disponibles.
  int get variantCount => variants.length;

  @override
  bool operator ==(Object other) => other is Chord && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Chord($name, variantes: $variantCount)';
}
