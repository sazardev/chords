/// Forma de escribir los catálogos: un acorde de referencia en vez de offsets.
///
/// `refShape('7', 'c7', 'Forma de Do 7', 'x32310', 'C')` describe el Do7 de
/// siempre; el generador deduce la cuerda de anclaje y los desplazamientos
/// para transportarlo a las doce raíces.
library;

import '../chord_shape_spec.dart';
import '../chord_theory.dart';

/// Digitación vacía: el generador la busca con el solucionador de dedos.
const List<int> kAutoFingers = <int>[0, 0, 0, 0, 0, 0];

/// Forma movible a partir de un acorde de referencia.
///
/// - [frets]: trastes de la sexta a la primera (`x32010`, o separados por
///   espacios si algún traste pasa de 9: `x 10 12 12 12 10`).
/// - [root]: nota raíz del acorde de referencia (`C`).
/// - [base]: traste del cejillo en la referencia (0 si es una forma abierta).
/// - [open] y [moved]: dificultad mínima abierta y desplazada; el generador
///   la sube si la digitación es más exigente.
MovableShapeSpec refShape(
  String quality,
  String id,
  String label,
  String frets,
  String root, {
  int base = 0,
  int open = 1,
  int moved = 1,
  bool openOnly = false,
  int maxBarre = 12,
}) {
  final List<int?> absolute = parseFrets(frets);
  final int anchor = absolute.indexWhere((int? f) => f != null);
  assert(anchor >= 0, 'La forma $id no suena ninguna cuerda');
  final int rootPc = pitchClassOf(root);
  final int anchorPc = (kStringTuning[anchor] + absolute[anchor]!) % 12;
  final List<int?> offsets = <int?>[
    for (final int? fret in absolute)
      if (fret == null)
        null
      else if (fret >= base)
        fret - base
      else
        throw ArgumentError('La forma $id tiene un traste bajo la base'),
  ];
  return MovableShapeSpec(
    qualityId: quality,
    id: id,
    rootString: anchor,
    positionLabel: label,
    fretOffsets: offsets,
    fingersOpen: kAutoFingers,
    fingersBarre: kAutoFingers,
    difficultyOpen: open,
    difficultyBarre: moved,
    tags: const <String>[],
    anchorSemitones: (anchorPc - rootPc) % 12,
    openOnly: openOnly,
    maxBarre: maxBarre,
  );
}

/// Trastes de un acorde escrito como texto (`x` = cuerda muda).
List<int?> parseFrets(String text) {
  final List<String> tokens = text.contains(' ')
      ? text.trim().split(RegExp(r'\s+'))
      : text.split('');
  assert(tokens.length == kStringCount, 'Hacen falta 6 cuerdas: $text');
  return <int?>[
    for (final String token in tokens)
      if (token.toLowerCase() == 'x') null else int.parse(token),
  ];
}
