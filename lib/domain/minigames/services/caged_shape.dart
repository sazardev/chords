import 'package:chords/domain/chords/entities/chord_variant.dart';
import 'package:chords/domain/chords/entities/variant_identity.dart';

/// Las cinco formas abiertas del sistema CAGED.
enum CagedShape {
  /// Forma de Do (raíz en la 5ª cuerda).
  c('C', 0),

  /// Forma de La (raíz en la 5ª cuerda).
  a('A', 9),

  /// Forma de Sol (raíz en la 6ª cuerda).
  g('G', 7),

  /// Forma de Mi (raíz en la 6ª cuerda).
  e('E', 4),

  /// Forma de Re (raíz en la 4ª cuerda).
  d('D', 2);

  /// Crea la forma con su letra y la nota de su acorde abierto.
  const CagedShape(this.letter, this.openRoot);

  /// Letra anglosajona de la forma.
  final String letter;

  /// Clase de tono del acorde abierto que da nombre a la forma.
  final int openRoot;

  /// Traste donde va la cejilla (o el capo) para tocar [root] con esta forma;
  /// `0` si el acorde es la propia forma abierta.
  int barreFretFor(int root) => (root - openRoot + 12) % 12;

  /// Resuelve una forma por su letra.
  static CagedShape? fromLetter(String letter) {
    for (final CagedShape shape in CagedShape.values) {
      if (shape.letter == letter) {
        return shape;
      }
    }
    return null;
  }

  /// Forma CAGED de una posición del banco.
  ///
  /// Lee el identificador estructurado de la posición (`e-maj7-shape-8`: la
  /// clave de la forma y su traste más bajo), no su nombre. La clave empieza
  /// por la letra de la forma; las formas que no son CAGED (power chords,
  /// disminuidos, aumentados, la forma de Fa o de Si) y los voicings
  /// buscados (tríadas, shells, drops) devuelven `null`.
  static CagedShape? ofVariant(ChordVariant variant) {
    final List<String> parts = variant.id.split('-');
    if (parts.length < 3) {
      return null;
    }
    final VariantIdentity identity = VariantIdentity.parse(
      parts.skip(2).join('-'),
    );
    if (!identity.isShape || _notCaged.hasMatch(identity.key)) {
      return null;
    }
    final RegExpMatch? match = _key.firstMatch(identity.key);
    return match == null ? null : fromLetter(match.group(1)!.toUpperCase());
  }

  /// La clave empieza por la letra de la forma y sigue con `-` o un dígito.
  static final RegExp _key = RegExp(r'^([acdeg])(?=[-\d])');

  /// Formas con letra de CAGED que no son formas CAGED.
  static final RegExp _notCaged = RegExp('power|aug|dim|sixth');
}
