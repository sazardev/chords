import 'package:chords/domain/chords/entities/chord_variant.dart';

/// Las cinco formas abiertas del sistema CAGED.
enum CagedShape {
  /// Forma de Do (raíz en la 5ª cuerda).
  c('C', 0, 'Do'),

  /// Forma de La (raíz en la 5ª cuerda).
  a('A', 9, 'La'),

  /// Forma de Sol (raíz en la 6ª cuerda).
  g('G', 7, 'Sol'),

  /// Forma de Mi (raíz en la 6ª cuerda).
  e('E', 4, 'Mi'),

  /// Forma de Re (raíz en la 4ª cuerda).
  d('D', 2, 'Re');

  /// Crea la forma con su letra, la nota de su acorde abierto y su nombre
  /// en las etiquetas de posición del banco.
  const CagedShape(this.letter, this.openRoot, this.bankName);

  /// Letra anglosajona de la forma.
  final String letter;

  /// Clase de tono del acorde abierto que da nombre a la forma.
  final int openRoot;

  /// Nombre con el que el banco etiqueta la posición (`Forma de Sol`).
  final String bankName;

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

  /// Forma CAGED de una posición del banco, por su etiqueta
  /// (`Forma de La · traste 3`); `null` si no es una de las cinco.
  static CagedShape? ofVariant(ChordVariant variant) {
    final RegExpMatch? match = _label.firstMatch(variant.positionLabel);
    if (match == null) {
      return null;
    }
    for (final CagedShape shape in CagedShape.values) {
      if (shape.bankName == match.group(1)) {
        return shape;
      }
    }
    return null;
  }

  static final RegExp _label = RegExp(r'^Forma de (Do|Re|Mi|Sol|La)(?=\s|$)');
}
