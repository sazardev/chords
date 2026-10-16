import 'package:meta/meta.dart';

/// Tipo de posición según cómo se construyó.
enum VariantKind {
  /// Forma del catálogo (CAGED, abierta o movible), con nombre propio.
  shape,

  /// Tríada en tres cuerdas contiguas, en posición fundamental o inversión.
  triad,

  /// Shell: raíz, tercera y séptima sin quinta.
  shell,

  /// Voicing de cuatro cuerdas contiguas que no es drop.
  voicing,

  /// Drop 2: acorde cerrado con la segunda voz bajada una octava.
  drop2,

  /// Drop 3: acorde cerrado con la tercera voz bajada una octava.
  drop3,
}

/// Lo que dice el identificador de una posición: de qué tipo es y, si la
/// encontró el buscador, en qué cuerdas está y qué nota suena en el bajo.
///
/// Los identificadores del banco son `e-maj7-shape-8` (forma + traste más
/// bajo) o `drop2-4321-b3` (tipo, cuerdas 4-3-2-1 y bajo a 3 semitonos de la
/// raíz). Con ellos la app deduce el nombre y las etiquetas sin guardarlos.
@immutable
class VariantIdentity {
  /// Crea la identidad.
  const VariantIdentity({
    required this.kind,
    required this.key,
    this.strings = const <int>[],
    this.bassInterval = 0,
  });

  /// Interpreta el identificador de una posición (sin el prefijo del acorde).
  factory VariantIdentity.parse(String id) {
    final RegExpMatch? search = _searched.firstMatch(id);
    if (search != null) {
      return VariantIdentity(
        kind: VariantKind.values.byName(search.group(1)!),
        key: id,
        strings: <int>[
          for (final String digit in search.group(2)!.split(''))
            int.parse(digit),
        ],
        bassInterval: int.parse(search.group(3)!),
      );
    }
    return VariantIdentity(
      kind: VariantKind.shape,
      key: id.replaceFirst(_fretSuffix, ''),
    );
  }

  static final RegExp _searched = RegExp(
    r'^(triad|shell|voicing|drop2|drop3)-(\d+)-b(\d+)$',
  );
  static final RegExp _fretSuffix = RegExp(r'-\d+$');

  /// Tipo de posición.
  final VariantKind kind;

  /// Clave de la forma (`e-maj7-shape`) o el propio identificador.
  final String key;

  /// Números de cuerda (6 = grave … 1 = aguda) de un voicing buscado.
  final List<int> strings;

  /// Semitonos entre la raíz y la nota del bajo (voicings buscados).
  final int bassInterval;

  /// `true` si la posición viene del catálogo de formas.
  bool get isShape => kind == VariantKind.shape;

  @override
  bool operator ==(Object other) =>
      other is VariantIdentity &&
      other.kind == kind &&
      other.key == key &&
      other.bassInterval == bassInterval;

  @override
  int get hashCode => Object.hash(kind, key, bassInterval);
}
